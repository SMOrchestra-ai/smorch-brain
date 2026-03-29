#!/usr/bin/env python3
"""
LinkedIn URL Normalization Utility

Normalizes LinkedIn profile URLs to canonical format:
  https://www.linkedin.com/in/username/

Handles:
- Missing protocol, www, trailing slash
- Query parameters and fragments
- Mixed case
- Sales Navigator URLs
- Various input formats

Usage:
    # Single URL
    python normalize-linkedin-url.py "linkedin.com/in/john-doe"

    # From stdin (one URL per line)
    cat urls.txt | python normalize-linkedin-url.py

    # JSON input (array of objects with profileUrl field)
    cat leads.json | python normalize-linkedin-url.py --json --field profileUrl

    # CSV input
    cat leads.csv | python normalize-linkedin-url.py --csv --column linkedin_url
"""

import sys
import json
import csv
import re
import argparse
from urllib.parse import urlparse, urljoin
from io import StringIO


def normalize_linkedin_url(url: str) -> dict:
    """
    Normalize a LinkedIn profile URL.

    Returns:
        dict with keys:
            - original: input URL
            - normalized: canonical URL or None if invalid
            - username: extracted username or None
            - valid: bool
            - error: error message or None
    """
    result = {
        "original": url,
        "normalized": None,
        "username": None,
        "valid": False,
        "error": None,
    }

    if not url or not isinstance(url, str):
        result["error"] = "Empty or non-string input"
        return result

    url = url.strip()

    # Add protocol if missing
    if not url.startswith("http"):
        if url.startswith("www."):
            url = "https://" + url
        elif url.startswith("linkedin.com"):
            url = "https://www." + url
        else:
            url = "https://www.linkedin.com" + (url if url.startswith("/") else "/" + url)

    # Parse URL
    try:
        parsed = urlparse(url)
    except Exception as e:
        result["error"] = f"URL parse error: {str(e)}"
        return result

    # Verify LinkedIn domain
    hostname = parsed.hostname or ""
    if "linkedin.com" not in hostname:
        result["error"] = f"Not a LinkedIn URL (host: {hostname})"
        return result

    # Extract path and find /in/username pattern
    path = parsed.path.strip("/")

    # Handle Sales Navigator URLs
    # Format: /sales/lead/ACwAAAxxxxxx,NAME,... or /sales/people/...
    if path.startswith("sales/"):
        result["error"] = "Sales Navigator URL — cannot extract vanity username. Need standard profile URL."
        return result

    # Standard profile: /in/username
    match = re.match(r"^in/([a-zA-Z0-9\-_.%]+)", path)
    if not match:
        result["error"] = f"No /in/username pattern found in path: /{path}"
        return result

    username = match.group(1).lower()

    # Decode percent-encoded characters commonly seen
    username = username.replace("%20", "-")

    # Build canonical URL
    normalized = f"https://www.linkedin.com/in/{username}/"

    result["normalized"] = normalized
    result["username"] = username
    result["valid"] = True

    return result


def process_plain_text(lines: list) -> list:
    """Process plain text input (one URL per line)."""
    results = []
    for line in lines:
        line = line.strip()
        if line and not line.startswith("#"):
            results.append(normalize_linkedin_url(line))
    return results


def process_json_input(data: str, field: str = "profileUrl") -> list:
    """Process JSON input (array of objects)."""
    try:
        parsed = json.loads(data)
    except json.JSONDecodeError as e:
        return [{"error": f"Invalid JSON: {str(e)}"}]

    if isinstance(parsed, list):
        items = parsed
    elif isinstance(parsed, dict):
        items = [parsed]
    else:
        return [{"error": "JSON must be an array or object"}]

    results = []
    for i, item in enumerate(items):
        if isinstance(item, str):
            result = normalize_linkedin_url(item)
        elif isinstance(item, dict):
            url = item.get(field, "")
            result = normalize_linkedin_url(url)
            result["index"] = i
            result["lead_data"] = {k: v for k, v in item.items() if k != field}
        else:
            result = {"error": f"Unexpected item type at index {i}", "index": i}
        results.append(result)

    return results


def process_csv_input(data: str, column: str = "linkedin_url") -> list:
    """Process CSV input."""
    reader = csv.DictReader(StringIO(data))
    results = []

    if column not in (reader.fieldnames or []):
        available = ", ".join(reader.fieldnames or [])
        return [{"error": f"Column '{column}' not found. Available: {available}"}]

    for i, row in enumerate(reader):
        url = row.get(column, "")
        result = normalize_linkedin_url(url)
        result["index"] = i
        result["row_data"] = {k: v for k, v in row.items() if k != column}
        results.append(result)

    return results


def generate_report(results: list) -> dict:
    """Generate summary report from normalization results."""
    total = len(results)
    valid = sum(1 for r in results if r.get("valid"))
    invalid = total - valid

    errors = {}
    for r in results:
        if r.get("error"):
            error_type = r["error"].split(":")[0] if ":" in r["error"] else r["error"]
            errors[error_type] = errors.get(error_type, 0) + 1

    return {
        "total_processed": total,
        "valid": valid,
        "invalid": invalid,
        "valid_pct": f"{(valid/total*100):.1f}%" if total > 0 else "0%",
        "error_breakdown": errors,
        "normalized_urls": [r["normalized"] for r in results if r.get("valid")],
        "failed": [
            {"original": r["original"], "error": r["error"]}
            for r in results
            if not r.get("valid")
        ],
    }


def main():
    parser = argparse.ArgumentParser(description="Normalize LinkedIn profile URLs")
    parser.add_argument("url", nargs="?", help="Single URL to normalize")
    parser.add_argument("--json", action="store_true", help="Input is JSON")
    parser.add_argument("--csv", action="store_true", help="Input is CSV")
    parser.add_argument("--field", default="profileUrl", help="JSON field name (default: profileUrl)")
    parser.add_argument("--column", default="linkedin_url", help="CSV column name (default: linkedin_url)")
    parser.add_argument("--report", action="store_true", help="Output summary report")

    args = parser.parse_args()

    # Single URL from argument
    if args.url:
        result = normalize_linkedin_url(args.url)
        if result["valid"]:
            print(result["normalized"])
        else:
            print(f"ERROR: {result['error']}", file=sys.stderr)
            sys.exit(1)
        return

    # Stdin processing
    if sys.stdin.isatty():
        parser.print_help()
        sys.exit(1)

    stdin_data = sys.stdin.read()

    if args.json:
        results = process_json_input(stdin_data, args.field)
    elif args.csv:
        results = process_csv_input(stdin_data, args.column)
    else:
        results = process_plain_text(stdin_data.splitlines())

    if args.report:
        report = generate_report(results)
        print(json.dumps(report, indent=2))
    else:
        print(json.dumps(results, indent=2))


if __name__ == "__main__":
    main()
