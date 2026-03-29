#!/usr/bin/env python3
"""
Cross-Channel Audit Script
Audits leads across Instantly, HeyReach, and GHL for:
- Timing conflicts (multiple touches same day)
- Orphaned enrollments (in channel but not in GHL)
- Missing tags or custom fields
- Duplicate enrollments (same lead, same channel, multiple campaigns)
- Opt-out violations

Input: JSON from stdin or sample data for demonstration
Output: Audit report with findings and recommended actions

Usage:
  echo '{"leads": [...]}' | python3 cross-channel-audit.py
  python3 cross-channel-audit.py --sample
  python3 cross-channel-audit.py --help
"""

import json
import sys
from datetime import datetime, timedelta
from collections import defaultdict


def parse_args():
    if '--help' in sys.argv or '-h' in sys.argv:
        print(__doc__)
        sys.exit(0)
    return '--sample' in sys.argv


def get_sample_data():
    """Sample data demonstrating various audit scenarios."""
    return {
        "leads": [
            {
                "email": "ahmed@techcorp.ae",
                "linkedin_url": "https://www.linkedin.com/in/ahmed-hassan/",
                "first_name": "Ahmed",
                "last_name": "Hassan",
                "company": "TechCorp",
                "ghl_contact_id": "ghl_001",
                "ghl_tags": ["campaign:mena-saas-feb", "channel:email", "channel:linkedin", "geo:mena"],
                "ghl_custom_fields": {
                    "signal_score": 4,
                    "last_touch_date": "2026-02-21T10:30:00Z",
                    "last_touch_channel": "email",
                    "active_channels": "email,linkedin",
                    "opted_out_channels": ""
                },
                "instantly_campaigns": [
                    {"id": "inst_001", "name": "MENA SaaS - Feb Email A", "status": "active"}
                ],
                "heyreach_campaigns": [
                    {"id": 12345, "name": "MENA SaaS - Feb LinkedIn", "status": "IN_PROGRESS"}
                ],
                "touch_log": [
                    {"date": "2026-02-20", "channel": "email", "action": "email_sent"},
                    {"date": "2026-02-21", "channel": "email", "action": "email_sent"},
                    {"date": "2026-02-21", "channel": "linkedin", "action": "connection_request"}
                ]
            },
            {
                "email": "sarah@startup.com",
                "linkedin_url": "https://www.linkedin.com/in/sarah-jones/",
                "first_name": "Sarah",
                "last_name": "Jones",
                "company": "StartupCo",
                "ghl_contact_id": None,
                "ghl_tags": [],
                "ghl_custom_fields": {},
                "instantly_campaigns": [
                    {"id": "inst_002", "name": "US B2B - Feb Email A", "status": "active"}
                ],
                "heyreach_campaigns": [],
                "touch_log": [
                    {"date": "2026-02-20", "channel": "email", "action": "email_sent"}
                ]
            },
            {
                "email": "mike@enterprise.com",
                "linkedin_url": "https://www.linkedin.com/in/mike-chen/",
                "first_name": "Mike",
                "last_name": "Chen",
                "company": "EnterpriseCorp",
                "ghl_contact_id": "ghl_003",
                "ghl_tags": ["campaign:us-enterprise-jan", "status:opted_out"],
                "ghl_custom_fields": {
                    "signal_score": 0,
                    "opted_out_channels": "email"
                },
                "instantly_campaigns": [
                    {"id": "inst_003", "name": "US Enterprise - Feb Email", "status": "active"}
                ],
                "heyreach_campaigns": [
                    {"id": 12347, "name": "US Enterprise - Feb LinkedIn", "status": "IN_PROGRESS"}
                ],
                "touch_log": [
                    {"date": "2026-02-21", "channel": "email", "action": "email_sent"}
                ]
            },
            {
                "email": "fatima@gulfco.ae",
                "linkedin_url": "https://www.linkedin.com/in/fatima-al-mansoori/",
                "first_name": "Fatima",
                "last_name": "Al Mansoori",
                "company": "GulfCo",
                "ghl_contact_id": "ghl_004",
                "ghl_tags": ["campaign:mena-saas-feb", "channel:email", "channel:linkedin", "geo:mena", "signal:hot"],
                "ghl_custom_fields": {
                    "signal_score": 9,
                    "last_touch_date": "2026-02-21T14:00:00Z",
                    "last_touch_channel": "linkedin",
                    "active_channels": "email,linkedin",
                    "last_reply_date": "2026-02-21T13:45:00Z",
                    "last_reply_channel": "linkedin"
                },
                "instantly_campaigns": [
                    {"id": "inst_001", "name": "MENA SaaS - Feb Email A", "status": "active"}
                ],
                "heyreach_campaigns": [
                    {"id": 12345, "name": "MENA SaaS - Feb LinkedIn", "status": "IN_PROGRESS"}
                ],
                "touch_log": [
                    {"date": "2026-02-19", "channel": "email", "action": "email_sent"},
                    {"date": "2026-02-20", "channel": "linkedin", "action": "connection_request"},
                    {"date": "2026-02-21", "channel": "linkedin", "action": "message_sent"}
                ]
            },
            {
                "email": "john@bigcorp.com",
                "linkedin_url": "https://www.linkedin.com/in/john-smith/",
                "first_name": "John",
                "last_name": "Smith",
                "company": "BigCorp",
                "ghl_contact_id": "ghl_005",
                "ghl_tags": ["campaign:us-b2b-feb", "channel:email"],
                "ghl_custom_fields": {
                    "signal_score": 2,
                    "last_touch_date": "2026-02-21T09:00:00Z",
                    "active_channels": "email",
                    "opted_out_channels": ""
                },
                "instantly_campaigns": [
                    {"id": "inst_004", "name": "US B2B - Feb Email A", "status": "active"},
                    {"id": "inst_005", "name": "US B2B - Feb Email B", "status": "active"}
                ],
                "heyreach_campaigns": [],
                "touch_log": [
                    {"date": "2026-02-21", "channel": "email", "action": "email_sent"},
                    {"date": "2026-02-21", "channel": "email", "action": "email_sent"}
                ]
            }
        ],
        "audit_date": "2026-02-22"
    }


def audit_timing_conflicts(leads, audit_date):
    """Check for multiple touches on same day or channel violations."""
    findings = []
    for lead in leads:
        daily_touches = defaultdict(list)
        for touch in lead.get("touch_log", []):
            daily_touches[touch["date"]].append(touch)

        for date, touches in daily_touches.items():
            # Check: >2 touches in one day
            if len(touches) > 2:
                findings.append({
                    "severity": "HIGH",
                    "type": "DAILY_LIMIT_EXCEEDED",
                    "lead": lead["email"],
                    "detail": f"{len(touches)} touches on {date} (max 2)",
                    "touches": touches,
                    "action": "Review sequence timing, add delay between channels"
                })

            # Check: same channel touched twice in one day
            channels_today = [t["channel"] for t in touches]
            for ch in set(channels_today):
                if channels_today.count(ch) > 1:
                    findings.append({
                        "severity": "HIGH",
                        "type": "SAME_CHANNEL_DOUBLE_TOUCH",
                        "lead": lead["email"],
                        "detail": f"Channel '{ch}' touched {channels_today.count(ch)}x on {date}",
                        "action": "Fix sequence — max 1 touch per channel per day"
                    })

            # Check: 2 different channels on same day (should have 24hr gap)
            unique_channels = set(channels_today)
            if len(unique_channels) > 1 and len(touches) >= 2:
                findings.append({
                    "severity": "MEDIUM",
                    "type": "MULTI_CHANNEL_SAME_DAY",
                    "lead": lead["email"],
                    "detail": f"Channels {unique_channels} both touched on {date}",
                    "action": "Verify 24hr gap between channel touches"
                })

    return findings


def audit_orphaned_enrollments(leads):
    """Check for leads in channel campaigns but not in GHL."""
    findings = []
    for lead in leads:
        has_instantly = len(lead.get("instantly_campaigns", [])) > 0
        has_heyreach = len(lead.get("heyreach_campaigns", [])) > 0
        has_ghl = lead.get("ghl_contact_id") is not None

        if (has_instantly or has_heyreach) and not has_ghl:
            channels = []
            if has_instantly:
                channels.append("Instantly")
            if has_heyreach:
                channels.append("HeyReach")
            findings.append({
                "severity": "HIGH",
                "type": "ORPHANED_ENROLLMENT",
                "lead": lead["email"],
                "detail": f"In {', '.join(channels)} but NOT in GHL",
                "action": "Create GHL contact immediately — GHL must be source of truth"
            })

    return findings


def audit_duplicate_enrollments(leads):
    """Check for same lead in multiple active campaigns on same channel."""
    findings = []
    for lead in leads:
        # Check Instantly duplicates
        active_instantly = [c for c in lead.get("instantly_campaigns", []) if c["status"] == "active"]
        if len(active_instantly) > 1:
            names = [c["name"] for c in active_instantly]
            findings.append({
                "severity": "HIGH",
                "type": "DUPLICATE_ENROLLMENT_EMAIL",
                "lead": lead["email"],
                "detail": f"In {len(active_instantly)} active Instantly campaigns: {names}",
                "action": "Remove from all but one campaign — lead will receive duplicate emails"
            })

        # Check HeyReach duplicates
        active_heyreach = [c for c in lead.get("heyreach_campaigns", [])
                          if c["status"] in ("IN_PROGRESS", "STARTING")]
        if len(active_heyreach) > 1:
            names = [c["name"] for c in active_heyreach]
            findings.append({
                "severity": "HIGH",
                "type": "DUPLICATE_ENROLLMENT_LINKEDIN",
                "lead": lead["email"],
                "detail": f"In {len(active_heyreach)} active HeyReach campaigns: {names}",
                "action": "Stop in all but one campaign — lead will receive duplicate messages"
            })

    return findings


def audit_opt_out_violations(leads):
    """Check for leads enrolled in channels they've opted out of."""
    findings = []
    for lead in leads:
        opted_out = lead.get("ghl_custom_fields", {}).get("opted_out_channels", "")
        if not opted_out:
            # Also check for status:opted_out tag
            if "status:opted_out" in lead.get("ghl_tags", []):
                opted_out = "all"

        if not opted_out:
            continue

        opted_out_channels = [c.strip() for c in opted_out.split(",") if c.strip()]

        if "all" in opted_out_channels or "status:opted_out" in lead.get("ghl_tags", []):
            if lead.get("instantly_campaigns") or lead.get("heyreach_campaigns"):
                findings.append({
                    "severity": "CRITICAL",
                    "type": "OPT_OUT_VIOLATION_GLOBAL",
                    "lead": lead["email"],
                    "detail": "OPTED OUT of all channels but still enrolled in campaigns",
                    "action": "IMMEDIATE: Remove from ALL campaigns across ALL channels"
                })
        else:
            if "email" in opted_out_channels and lead.get("instantly_campaigns"):
                active = [c for c in lead["instantly_campaigns"] if c["status"] == "active"]
                if active:
                    findings.append({
                        "severity": "CRITICAL",
                        "type": "OPT_OUT_VIOLATION_EMAIL",
                        "lead": lead["email"],
                        "detail": f"Opted out of email but in {len(active)} active Instantly campaigns",
                        "action": "IMMEDIATE: Remove from Instantly, add to suppression list"
                    })

            if "linkedin" in opted_out_channels and lead.get("heyreach_campaigns"):
                active = [c for c in lead["heyreach_campaigns"]
                         if c["status"] in ("IN_PROGRESS", "STARTING")]
                if active:
                    findings.append({
                        "severity": "CRITICAL",
                        "type": "OPT_OUT_VIOLATION_LINKEDIN",
                        "lead": lead["email"],
                        "detail": f"Opted out of LinkedIn but in {len(active)} active HeyReach campaigns",
                        "action": "IMMEDIATE: Stop in HeyReach campaigns"
                    })

    return findings


def audit_reply_not_paused(leads):
    """Check for leads who replied but still have active sequences."""
    findings = []
    for lead in leads:
        cf = lead.get("ghl_custom_fields", {})
        last_reply = cf.get("last_reply_date")
        if not last_reply:
            continue

        reply_channel = cf.get("last_reply_channel", "unknown")

        # Lead replied — check if other channels are still active
        active_instantly = [c for c in lead.get("instantly_campaigns", []) if c["status"] == "active"]
        active_heyreach = [c for c in lead.get("heyreach_campaigns", [])
                          if c["status"] in ("IN_PROGRESS", "STARTING")]

        other_active = []
        if reply_channel != "email" and active_instantly:
            other_active.append(f"Instantly ({len(active_instantly)} campaigns)")
        if reply_channel != "linkedin" and active_heyreach:
            other_active.append(f"HeyReach ({len(active_heyreach)} campaigns)")

        if other_active:
            findings.append({
                "severity": "HIGH",
                "type": "REPLY_NOT_PAUSED",
                "lead": lead["email"],
                "detail": f"Replied on {reply_channel} at {last_reply} but still active in: {', '.join(other_active)}",
                "action": "IMMEDIATE: Pause/stop all other channel sequences"
            })

    return findings


def audit_missing_tags(leads):
    """Check for leads missing required tags or custom fields."""
    findings = []
    required_tag_prefixes = ["campaign:", "geo:"]

    for lead in leads:
        if not lead.get("ghl_contact_id"):
            continue  # Already caught by orphaned enrollment audit

        tags = lead.get("ghl_tags", [])
        cf = lead.get("ghl_custom_fields", {})

        # Check required tags
        for prefix in required_tag_prefixes:
            has_tag = any(t.startswith(prefix) for t in tags)
            if not has_tag:
                findings.append({
                    "severity": "LOW",
                    "type": "MISSING_TAG",
                    "lead": lead["email"],
                    "detail": f"Missing '{prefix}*' tag in GHL",
                    "action": f"Add appropriate {prefix} tag for tracking"
                })

        # Check channel tags match actual enrollments
        has_email_tag = any(t == "channel:email" for t in tags)
        has_linkedin_tag = any(t == "channel:linkedin" for t in tags)
        in_instantly = len(lead.get("instantly_campaigns", [])) > 0
        in_heyreach = len(lead.get("heyreach_campaigns", [])) > 0

        if in_instantly and not has_email_tag:
            findings.append({
                "severity": "LOW",
                "type": "MISSING_CHANNEL_TAG",
                "lead": lead["email"],
                "detail": "In Instantly campaign but missing channel:email tag",
                "action": "Add channel:email tag to GHL contact"
            })
        if in_heyreach and not has_linkedin_tag:
            findings.append({
                "severity": "LOW",
                "type": "MISSING_CHANNEL_TAG",
                "lead": lead["email"],
                "detail": "In HeyReach campaign but missing channel:linkedin tag",
                "action": "Add channel:linkedin tag to GHL contact"
            })

        # Check critical custom fields
        if in_instantly or in_heyreach:
            if not cf.get("signal_score") and cf.get("signal_score") != 0:
                findings.append({
                    "severity": "LOW",
                    "type": "MISSING_FIELD",
                    "lead": lead["email"],
                    "detail": "Missing signal_score custom field",
                    "action": "Initialize signal_score to 0"
                })

    return findings


def generate_report(all_findings, leads, audit_date):
    """Generate formatted audit report."""
    severity_order = {"CRITICAL": 0, "HIGH": 1, "MEDIUM": 2, "LOW": 3}
    all_findings.sort(key=lambda f: severity_order.get(f["severity"], 99))

    # Summary counts
    by_severity = defaultdict(int)
    by_type = defaultdict(int)
    for f in all_findings:
        by_severity[f["severity"]] += 1
        by_type[f["type"]] += 1

    report = []
    report.append("=" * 70)
    report.append("CROSS-CHANNEL AUDIT REPORT")
    report.append(f"Date: {audit_date}")
    report.append(f"Leads Audited: {len(leads)}")
    report.append(f"Total Findings: {len(all_findings)}")
    report.append("=" * 70)

    report.append("")
    report.append("SEVERITY SUMMARY")
    report.append("-" * 40)
    for sev in ["CRITICAL", "HIGH", "MEDIUM", "LOW"]:
        count = by_severity.get(sev, 0)
        indicator = "🔴" if sev == "CRITICAL" else "🟠" if sev == "HIGH" else "🟡" if sev == "MEDIUM" else "🟢"
        report.append(f"  {indicator} {sev}: {count}")

    report.append("")
    report.append("FINDINGS BY TYPE")
    report.append("-" * 40)
    for ftype, count in sorted(by_type.items(), key=lambda x: -x[1]):
        report.append(f"  {ftype}: {count}")

    report.append("")
    report.append("DETAILED FINDINGS")
    report.append("=" * 70)

    current_severity = None
    for f in all_findings:
        if f["severity"] != current_severity:
            current_severity = f["severity"]
            report.append("")
            report.append(f"--- {current_severity} ---")

        report.append(f"")
        report.append(f"  [{f['type']}] {f['lead']}")
        report.append(f"  Detail: {f['detail']}")
        report.append(f"  Action: {f['action']}")

    # Prioritized action plan
    report.append("")
    report.append("=" * 70)
    report.append("PRIORITIZED ACTION PLAN")
    report.append("=" * 70)

    critical = [f for f in all_findings if f["severity"] == "CRITICAL"]
    high = [f for f in all_findings if f["severity"] == "HIGH"]

    if critical:
        report.append("")
        report.append("🔴 IMMEDIATE (do now):")
        for i, f in enumerate(critical, 1):
            report.append(f"  {i}. {f['lead']}: {f['action']}")

    if high:
        report.append("")
        report.append("🟠 URGENT (do today):")
        for i, f in enumerate(high, 1):
            report.append(f"  {i}. {f['lead']}: {f['action']}")

    if not critical and not high:
        report.append("")
        report.append("✅ No critical or high-severity issues found. Stack is healthy.")

    report.append("")
    report.append("=" * 70)
    report.append("END OF AUDIT REPORT")
    report.append("=" * 70)

    return "\n".join(report)


def main():
    use_sample = parse_args()

    if use_sample:
        data = get_sample_data()
    else:
        try:
            raw = sys.stdin.read()
            if not raw.strip():
                print("No input received. Use --sample for demo or pipe JSON via stdin.")
                sys.exit(1)
            data = json.loads(raw)
        except json.JSONDecodeError as e:
            print(f"Invalid JSON input: {e}")
            sys.exit(1)

    leads = data.get("leads", [])
    audit_date = data.get("audit_date", datetime.now().strftime("%Y-%m-%d"))

    if not leads:
        print("No leads found in input data.")
        sys.exit(1)

    # Run all audit checks
    all_findings = []
    all_findings.extend(audit_timing_conflicts(leads, audit_date))
    all_findings.extend(audit_orphaned_enrollments(leads))
    all_findings.extend(audit_duplicate_enrollments(leads))
    all_findings.extend(audit_opt_out_violations(leads))
    all_findings.extend(audit_reply_not_paused(leads))
    all_findings.extend(audit_missing_tags(leads))

    # Generate and print report
    report = generate_report(all_findings, leads, audit_date)
    print(report)

    # Also output JSON summary for programmatic use
    summary = {
        "audit_date": audit_date,
        "leads_audited": len(leads),
        "total_findings": len(all_findings),
        "by_severity": {
            "CRITICAL": len([f for f in all_findings if f["severity"] == "CRITICAL"]),
            "HIGH": len([f for f in all_findings if f["severity"] == "HIGH"]),
            "MEDIUM": len([f for f in all_findings if f["severity"] == "MEDIUM"]),
            "LOW": len([f for f in all_findings if f["severity"] == "LOW"])
        },
        "findings": all_findings
    }

    # Write JSON to stderr for programmatic consumption
    sys.stderr.write(json.dumps(summary, indent=2))


if __name__ == "__main__":
    main()
