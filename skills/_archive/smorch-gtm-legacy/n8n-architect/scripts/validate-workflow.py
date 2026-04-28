#!/usr/bin/env python3
"""
Validate n8n workflow JSON structure before deployment.

Usage:
    python validate-workflow.py workflow.json
    python validate-workflow.py --stdin < workflow.json

Checks:
    1. Valid JSON structure
    2. Required top-level fields (name, nodes, connections)
    3. Node structure validation (name, type, position)
    4. Connection integrity (referenced nodes exist)
    5. Naming conventions (no default node names)
    6. Error handling presence (Error Trigger node)
    7. Credential placeholder detection
    8. Idempotency patterns for webhook-triggered workflows
"""

import json
import sys
import os
from typing import Any

# Default n8n node names that should be renamed
DEFAULT_NAMES = {
    "HTTP Request", "HTTP Request1", "HTTP Request2",
    "Function", "Function1", "Function2",
    "IF", "IF1", "Switch", "Switch1",
    "Set", "Set1", "Code", "Code1",
    "Webhook", "Webhook1",
    "Slack", "Slack1",
    "Google Sheets", "Google Sheets1",
    "Merge", "Merge1",
    "Wait", "Wait1",
    "SplitInBatches", "SplitInBatches1",
    "NoOp", "NoOp1",
}

# Nodes that indicate error handling
ERROR_HANDLER_TYPES = {
    "n8n-nodes-base.errorTrigger",
}

# Webhook trigger types
WEBHOOK_TYPES = {
    "n8n-nodes-base.webhook",
    "n8n-nodes-base.webhookTest",
}


class ValidationResult:
    def __init__(self):
        self.errors: list[str] = []
        self.warnings: list[str] = []
        self.info: list[str] = []

    def error(self, msg: str):
        self.errors.append(f"ERROR: {msg}")

    def warn(self, msg: str):
        self.warnings.append(f"WARNING: {msg}")

    def add_info(self, msg: str):
        self.info.append(f"INFO: {msg}")

    @property
    def is_valid(self) -> bool:
        return len(self.errors) == 0

    def summary(self) -> str:
        lines = []
        lines.append("=" * 60)
        lines.append("n8n Workflow Validation Report")
        lines.append("=" * 60)

        if self.errors:
            lines.append(f"\n ERRORS ({len(self.errors)}):")
            for e in self.errors:
                lines.append(f"  {e}")

        if self.warnings:
            lines.append(f"\n WARNINGS ({len(self.warnings)}):")
            for w in self.warnings:
                lines.append(f"  {w}")

        if self.info:
            lines.append(f"\n INFO ({len(self.info)}):")
            for i in self.info:
                lines.append(f"  {i}")

        lines.append("\n" + "=" * 60)
        if self.is_valid:
            lines.append("RESULT: VALID (safe to deploy)")
        else:
            lines.append("RESULT: INVALID (fix errors before deploying)")
        lines.append("=" * 60)

        return "\n".join(lines)


def validate_workflow(workflow: dict[str, Any]) -> ValidationResult:
    result = ValidationResult()

    # 1. Required top-level fields
    required_fields = ["name", "nodes", "connections"]
    for field in required_fields:
        if field not in workflow:
            result.error(f"Missing required field: '{field}'")

    if not result.is_valid:
        return result

    # 2. Workflow name
    name = workflow.get("name", "")
    if not name:
        result.error("Workflow name is empty")
    elif not any(name.startswith(f"[{cat}]") for cat in
                 ["Signal", "Sequence", "Enrich", "Report", "Content", "Util", "Sub", "Test"]):
        result.warn(
            f"Workflow name '{name}' doesn't follow naming convention: "
            "[Category] - Description"
        )

    # 3. Node validation
    nodes = workflow.get("nodes", [])
    if not nodes:
        result.error("Workflow has no nodes")
        return result

    node_names = set()
    node_types = set()
    has_error_handler = False
    has_webhook_trigger = False
    credential_placeholders = []

    for i, node in enumerate(nodes):
        # Required node fields
        if "name" not in node:
            result.error(f"Node at index {i} has no name")
            continue
        if "type" not in node:
            result.error(f"Node '{node.get('name', f'index-{i}')}' has no type")
        if "position" not in node:
            result.warn(f"Node '{node['name']}' has no position (will be auto-placed)")

        node_name = node.get("name", "")
        node_type = node.get("type", "")

        # Track names for connection validation
        node_names.add(node_name)
        node_types.add(node_type)

        # Check for default names
        if node_name in DEFAULT_NAMES:
            result.warn(
                f"Node '{node_name}' uses a default name. "
                "Rename to describe its purpose (e.g., 'Score - Apply Weights')"
            )

        # Check for error handlers
        if node_type in ERROR_HANDLER_TYPES:
            has_error_handler = True

        # Check for webhook triggers
        if node_type in WEBHOOK_TYPES:
            has_webhook_trigger = True

        # Check for credential placeholders
        credentials = node.get("credentials", {})
        for cred_type, cred_info in credentials.items():
            cred_id = cred_info.get("id", "")
            if "PLACEHOLDER" in str(cred_id).upper():
                credential_placeholders.append(
                    f"{node_name} → {cred_type} (ID: {cred_id})"
                )

    # 4. Error handling check
    if not has_error_handler:
        result.warn(
            "No Error Trigger node found. Every production workflow should "
            "have error handling to prevent silent failures."
        )

    # 5. Connection validation
    connections = workflow.get("connections", {})
    for source_node, conn_data in connections.items():
        if source_node not in node_names:
            result.error(
                f"Connection references non-existent source node: '{source_node}'"
            )

        if "main" in conn_data:
            for output_idx, outputs in enumerate(conn_data["main"]):
                for conn in outputs:
                    target = conn.get("node", "")
                    if target and target not in node_names:
                        result.error(
                            f"Connection from '{source_node}' output {output_idx} "
                            f"references non-existent target: '{target}'"
                        )

    # 6. Idempotency check for webhook workflows
    if has_webhook_trigger:
        # Look for IF nodes or dedup patterns
        has_dedup = any(
            "duplicate" in node.get("name", "").lower() or
            "idempoten" in node.get("name", "").lower() or
            "already" in node.get("name", "").lower() or
            "exists" in node.get("name", "").lower()
            for node in nodes
        )
        if not has_dedup:
            result.warn(
                "Webhook-triggered workflow has no apparent idempotency check. "
                "Webhook events are frequently duplicated — consider adding a "
                "dedup check (tag check, campaign membership check, or event ID dedup)."
            )

    # 7. Credential placeholders info
    if credential_placeholders:
        result.add_info(
            f"Found {len(credential_placeholders)} credential placeholder(s) "
            "that need to be mapped:"
        )
        for cp in credential_placeholders:
            result.add_info(f"  → {cp}")

    # 8. Summary stats
    result.add_info(f"Workflow: {name}")
    result.add_info(f"Total nodes: {len(nodes)}")
    result.add_info(f"Has error handling: {'Yes' if has_error_handler else 'No'}")
    result.add_info(f"Has webhook trigger: {'Yes' if has_webhook_trigger else 'No'}")

    return result


def main():
    if len(sys.argv) < 2 and sys.stdin.isatty():
        print("Usage: python validate-workflow.py <workflow.json>")
        print("       python validate-workflow.py --stdin < workflow.json")
        sys.exit(1)

    if "--stdin" in sys.argv or not sys.stdin.isatty():
        raw = sys.stdin.read()
    else:
        filepath = sys.argv[1]
        if not os.path.exists(filepath):
            print(f"File not found: {filepath}")
            sys.exit(1)
        with open(filepath, "r") as f:
            raw = f.read()

    try:
        workflow = json.loads(raw)
    except json.JSONDecodeError as e:
        print(f"Invalid JSON: {e}")
        sys.exit(1)

    result = validate_workflow(workflow)
    print(result.summary())
    sys.exit(0 if result.is_valid else 1)


if __name__ == "__main__":
    main()
