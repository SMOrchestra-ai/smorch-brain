#!/usr/bin/env python3
"""
Campaign Health Check Script
Evaluates campaign analytics data and produces a structured health report.

Usage:
    Feed campaign analytics JSON from Instantly MCP tools into this script.
    It calculates rates, compares against benchmarks, and outputs diagnosis.

Input: JSON dict with campaign analytics fields
Output: Structured health report with recommendations
"""

import json
import sys
from datetime import datetime

# --- Benchmarks ---
BENCHMARKS = {
    "open_rate": {"healthy": 0.50, "warning": 0.30, "label": "Open Rate"},
    "reply_rate": {"healthy": 0.05, "warning": 0.02, "label": "Reply Rate"},
    "bounce_rate": {"healthy_max": 0.02, "warning_max": 0.05, "label": "Bounce Rate"},
    "unsub_rate": {"healthy_max": 0.005, "warning_max": 0.02, "label": "Unsubscribe Rate"},
    "opp_rate": {"healthy": 0.01, "warning": 0.005, "label": "Opportunity Rate"},
}

# --- Diagnostic Matrix ---
DIAGNOSTICS = {
    "low_opens": {
        "symptom": "Open rate below warning threshold",
        "likely_cause": "Deliverability / inbox placement issue",
        "checks": [
            "Check warmup scores (all accounts ≥95?)",
            "Verify DNS records (SPF, DKIM, DMARC)",
            "Review subject lines for spam triggers",
            "Check if open_tracking is enabled (required for open data)",
        ],
    },
    "low_replies": {
        "symptom": "Reply rate below warning threshold",
        "likely_cause": "Messaging / targeting issue",
        "checks": [
            "Review email copy — is personalization specific enough?",
            "Check CTA — is it low-friction? (question, not demand)",
            "Verify ICP targeting — are these the right leads?",
            "Check email length — under 150 words?",
            "Review subject line relevance",
        ],
    },
    "high_bounces": {
        "symptom": "Bounce rate above warning threshold",
        "likely_cause": "List quality issue",
        "checks": [
            "IMMEDIATE: Pause campaign if bounce >5%",
            "Check lead source — were emails verified?",
            "Run email verification on remaining leads",
            "Remove bounced leads from all campaigns",
            "Review Clay enrichment quality for this segment",
        ],
    },
    "high_unsubs": {
        "symptom": "Unsubscribe rate above warning threshold",
        "likely_cause": "Targeting / relevance issue",
        "checks": [
            "Review ICP fit — are leads in the right segment?",
            "Check email frequency — too many follow-ups?",
            "Review content relevance to recipient's role",
            "Consider narrowing targeting criteria",
        ],
    },
    "high_auto_replies": {
        "symptom": "Auto-reply rate above 20%",
        "likely_cause": "Lead data quality / timing issue",
        "checks": [
            "Check if sending during holiday period",
            "Review lead roles — too many generic/role-based emails?",
            "Filter out known OOO patterns from leads",
            "Adjust sending schedule to avoid known vacation periods",
        ],
    },
}


def calculate_rates(data: dict) -> dict:
    """Calculate all rates from raw analytics data."""
    sent = data.get("sent", 0)
    contacted = data.get("contacted", 0)
    unique_opened = data.get("unique_opened", 0)
    unique_replies = data.get("unique_replies", 0)
    unique_replies_auto = data.get("unique_replies_automatic", 0)
    bounced = data.get("bounced", sent - contacted if sent > contacted else 0)
    unsubscribed = data.get("unsubscribed", 0)
    unique_opportunities = data.get("unique_opportunities", 0)

    rates = {}
    if contacted > 0:
        rates["open_rate"] = unique_opened / contacted if unique_opened else None
        rates["reply_rate"] = unique_replies / contacted
        rates["unsub_rate"] = unsubscribed / contacted
        rates["opp_rate"] = unique_opportunities / contacted
    else:
        rates["open_rate"] = None
        rates["reply_rate"] = 0
        rates["unsub_rate"] = 0
        rates["opp_rate"] = 0

    if sent > 0:
        rates["bounce_rate"] = bounced / sent
    else:
        rates["bounce_rate"] = 0

    if unique_replies > 0:
        rates["auto_reply_pct"] = unique_replies_auto / unique_replies
    else:
        rates["auto_reply_pct"] = 0

    rates["_raw"] = {
        "sent": sent,
        "contacted": contacted,
        "unique_opened": unique_opened,
        "unique_replies": unique_replies,
        "unique_replies_auto": unique_replies_auto,
        "bounced": bounced,
        "unsubscribed": unsubscribed,
        "unique_opportunities": unique_opportunities,
    }

    return rates


def assess_metric(metric_name: str, value: float) -> str:
    """Return HEALTHY, WARNING, or CRITICAL for a given metric."""
    if value is None:
        return "N/A"

    bench = BENCHMARKS.get(metric_name)
    if not bench:
        return "UNKNOWN"

    # Metrics where higher is better (open, reply, opp)
    if "healthy" in bench:
        if value >= bench["healthy"]:
            return "HEALTHY"
        elif value >= bench["warning"]:
            return "WARNING"
        else:
            return "CRITICAL"
    # Metrics where lower is better (bounce, unsub)
    elif "healthy_max" in bench:
        if value <= bench["healthy_max"]:
            return "HEALTHY"
        elif value <= bench["warning_max"]:
            return "WARNING"
        else:
            return "CRITICAL"

    return "UNKNOWN"


def diagnose(rates: dict) -> list:
    """Return list of triggered diagnostics based on rates."""
    issues = []

    if rates.get("open_rate") is not None and rates["open_rate"] < 0.30:
        issues.append(DIAGNOSTICS["low_opens"])

    if rates["reply_rate"] < 0.02:
        issues.append(DIAGNOSTICS["low_replies"])

    if rates["bounce_rate"] > 0.05:
        issues.append(DIAGNOSTICS["high_bounces"])
    elif rates["bounce_rate"] > 0.02:
        issues.append(DIAGNOSTICS["high_bounces"])

    if rates["unsub_rate"] > 0.02:
        issues.append(DIAGNOSTICS["high_unsubs"])

    if rates.get("auto_reply_pct", 0) > 0.20:
        issues.append(DIAGNOSTICS["high_auto_replies"])

    return issues


def generate_report(campaign_name: str, data: dict) -> dict:
    """Generate full health report from campaign analytics."""
    rates = calculate_rates(data)
    raw = rates["_raw"]

    # Assess each metric
    assessments = {}
    for metric in ["open_rate", "reply_rate", "bounce_rate", "unsub_rate", "opp_rate"]:
        val = rates.get(metric)
        status = assess_metric(metric, val)
        label = BENCHMARKS[metric]["label"]
        assessments[metric] = {
            "label": label,
            "value": f"{val:.1%}" if val is not None else "N/A (tracking off)",
            "status": status,
        }

    # Overall health
    statuses = [a["status"] for a in assessments.values() if a["status"] != "N/A"]
    if "CRITICAL" in statuses:
        overall = "CRITICAL"
    elif "WARNING" in statuses:
        overall = "WARNING"
    else:
        overall = "HEALTHY"

    # Diagnostics
    issues = diagnose(rates)

    # Priority actions
    actions = {"P1_immediate": [], "P2_this_week": [], "P3_next_cycle": []}

    if rates["bounce_rate"] > 0.05:
        actions["P1_immediate"].append("PAUSE campaign — bounce rate critical. Clean list before resuming.")
    if rates.get("open_rate") is not None and rates["open_rate"] < 0.30:
        actions["P1_immediate"].append("Check warmup scores and DNS. Deliverability issue likely.")

    if rates["reply_rate"] < 0.02:
        actions["P2_this_week"].append("Rewrite email copy — focus on personalization and CTA clarity.")
    if rates["bounce_rate"] > 0.02:
        actions["P2_this_week"].append("Run email verification on remaining leads. Review lead source quality.")
    if rates["unsub_rate"] > 0.005:
        actions["P2_this_week"].append("Review targeting — narrow ICP or improve relevance.")

    if rates["reply_rate"] >= 0.02 and rates["reply_rate"] < 0.05:
        actions["P3_next_cycle"].append("A/B test subject lines and opening lines for next batch.")
    if rates.get("opp_rate", 0) < 0.01:
        actions["P3_next_cycle"].append("Review opportunity tagging — are positive replies being captured?")

    # Categorization
    if rates["bounce_rate"] > 0.05 or rates["unsub_rate"] > 0.02:
        category = "PAUSE"
        category_emoji = "🛑"
    elif rates["reply_rate"] < 0.03 or rates["bounce_rate"] > 0.03:
        category = "FIX"
        category_emoji = "⚠️"
    elif rates["reply_rate"] >= 0.05 and rates["bounce_rate"] < 0.02:
        category = "SCALE"
        category_emoji = "✅"
    else:
        category = "TEST"
        category_emoji = "→"

    report = {
        "campaign_name": campaign_name,
        "generated_at": datetime.now().isoformat(),
        "overall_health": overall,
        "category": f"{category_emoji} {category}",
        "raw_numbers": raw,
        "metrics": assessments,
        "issues_detected": len(issues),
        "diagnostics": issues,
        "priority_actions": actions,
    }

    return report


def format_report_text(report: dict) -> str:
    """Format report as readable text."""
    lines = []
    lines.append(f"## Campaign Health: {report['campaign_name']}")
    lines.append(f"Generated: {report['generated_at']}")
    lines.append(f"Overall: **{report['overall_health']}** | Category: {report['category']}")
    lines.append("")

    lines.append("### Metrics")
    for key, m in report["metrics"].items():
        lines.append(f"  {m['label']}: {m['value']} [{m['status']}]")
    lines.append("")

    lines.append("### Raw Numbers")
    raw = report["raw_numbers"]
    lines.append(f"  Sent: {raw['sent']} | Contacted: {raw['contacted']}")
    lines.append(f"  Replies: {raw['unique_replies']} | Bounced: {raw['bounced']}")
    lines.append(f"  Opportunities: {raw['unique_opportunities']}")
    lines.append("")

    if report["diagnostics"]:
        lines.append(f"### Issues Detected ({report['issues_detected']})")
        for diag in report["diagnostics"]:
            lines.append(f"  **{diag['symptom']}**")
            lines.append(f"  Likely cause: {diag['likely_cause']}")
            for check in diag["checks"]:
                lines.append(f"    - {check}")
            lines.append("")

    lines.append("### Priority Actions")
    for priority, items in report["priority_actions"].items():
        if items:
            lines.append(f"  **{priority}:**")
            for item in items:
                lines.append(f"    - {item}")
    lines.append("")

    return "\n".join(lines)


# --- Main ---
if __name__ == "__main__":
    # Example usage with sample data
    sample_data = {
        "sent": 500,
        "contacted": 480,
        "new_leads_contacted": 200,
        "unique_opened": 144,
        "unique_replies": 8,
        "unique_replies_automatic": 2,
        "bounced": 20,
        "unsubscribed": 3,
        "unique_opportunities": 2,
    }

    # Accept JSON from stdin or use sample
    if not sys.stdin.isatty():
        try:
            input_data = json.load(sys.stdin)
            campaign_name = input_data.get("campaign_name", "Unknown Campaign")
            analytics = input_data.get("analytics", input_data)
        except json.JSONDecodeError:
            print("Error: Invalid JSON input", file=sys.stderr)
            sys.exit(1)
    else:
        campaign_name = "Sample Campaign — Health Check Demo"
        analytics = sample_data

    report = generate_report(campaign_name, analytics)
    print(format_report_text(report))
    print("\n---\nJSON Report:")
    print(json.dumps(report, indent=2, default=str))
