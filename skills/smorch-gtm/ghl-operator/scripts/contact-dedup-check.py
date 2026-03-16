#!/usr/bin/env python3
"""
Contact Deduplication Checker for GHL/SalesMfast

Validates a list of contacts against dedup rules before bulk import.
Takes a CSV/JSON input and identifies potential duplicates by email and phone.

Usage:
    python contact-dedup-check.py input.csv --output dedup_report.json
    python contact-dedup-check.py input.json --output dedup_report.json

Input CSV format:
    first_name,last_name,email,phone,company,source

Input JSON format:
    [{"first_name": "...", "last_name": "...", "email": "...", "phone": "...", ...}]

Output: JSON report with:
    - duplicates_within_file: contacts that share email/phone within the input
    - missing_email: contacts without email (need manual dedup key)
    - invalid_phone: phone numbers not in E.164 format
    - mena_contacts: contacts with MENA phone numbers (auto-WhatsApp eligible)
    - ready_to_import: clean contacts ready for GHL import
    - summary: counts and recommendations
"""

import json
import csv
import re
import sys
import os
from collections import defaultdict
from datetime import datetime


# E.164 phone format regex
E164_PATTERN = re.compile(r'^\+[1-9]\d{6,14}$')

# MENA phone prefixes
MENA_PREFIXES = {
    '+971': 'UAE',
    '+966': 'Saudi Arabia',
    '+974': 'Qatar',
    '+965': 'Kuwait',
    '+973': 'Bahrain',
    '+968': 'Oman',
    '+962': 'Jordan',
    '+961': 'Lebanon',
    '+20': 'Egypt',
    '+212': 'Morocco',
    '+216': 'Tunisia'
}

# Gulf prefixes specifically (WhatsApp primary)
GULF_PREFIXES = ['+971', '+966', '+974', '+965', '+973', '+968']


def normalize_phone(phone: str) -> str:
    """Normalize phone to E.164 format."""
    if not phone:
        return ''

    # Remove spaces, dashes, parentheses
    phone = re.sub(r'[\s\-\(\)\.]+', '', phone.strip())

    # Handle common formats
    if phone.startswith('00'):
        phone = '+' + phone[2:]
    elif phone.startswith('0') and len(phone) > 5:
        # Could be local format — can't reliably convert without country context
        return phone  # Return as-is, flag as needing review
    elif not phone.startswith('+'):
        phone = '+' + phone

    return phone


def detect_mena(phone: str) -> tuple:
    """Check if phone is MENA. Returns (is_mena, country, is_gulf)."""
    for prefix, country in MENA_PREFIXES.items():
        if phone.startswith(prefix):
            is_gulf = prefix in GULF_PREFIXES
            return True, country, is_gulf
    return False, None, False


def validate_email(email: str) -> bool:
    """Basic email validation."""
    if not email:
        return False
    pattern = re.compile(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
    return bool(pattern.match(email.strip().lower()))


def load_contacts(filepath: str) -> list:
    """Load contacts from CSV or JSON."""
    ext = os.path.splitext(filepath)[1].lower()

    if ext == '.csv':
        contacts = []
        with open(filepath, 'r', encoding='utf-8-sig') as f:
            reader = csv.DictReader(f)
            for row in reader:
                contacts.append(dict(row))
        return contacts

    elif ext == '.json':
        with open(filepath, 'r', encoding='utf-8') as f:
            data = json.load(f)
            if isinstance(data, list):
                return data
            elif isinstance(data, dict) and 'contacts' in data:
                return data['contacts']
            else:
                raise ValueError("JSON must be an array or have a 'contacts' key")

    else:
        raise ValueError(f"Unsupported file format: {ext}. Use .csv or .json")


def run_dedup_check(contacts: list) -> dict:
    """Run full dedup analysis on contact list."""

    email_index = defaultdict(list)  # email → [row indices]
    phone_index = defaultdict(list)  # phone → [row indices]

    duplicates_within_file = []
    missing_email = []
    invalid_phone = []
    invalid_email = []
    mena_contacts = []
    ready_to_import = []

    for i, contact in enumerate(contacts):
        email = (contact.get('email') or '').strip().lower()
        phone_raw = contact.get('phone') or ''
        phone = normalize_phone(phone_raw)
        first_name = contact.get('first_name') or contact.get('firstName') or ''
        last_name = contact.get('last_name') or contact.get('lastName') or ''
        company = contact.get('company') or ''

        issues = []

        # Email checks
        if not email:
            missing_email.append({
                'row': i + 1,
                'name': f"{first_name} {last_name}".strip(),
                'phone': phone,
                'company': company,
                'issue': 'No email — manual dedup required'
            })
            issues.append('missing_email')
        elif not validate_email(email):
            invalid_email.append({
                'row': i + 1,
                'email': email,
                'name': f"{first_name} {last_name}".strip(),
                'issue': f'Invalid email format: {email}'
            })
            issues.append('invalid_email')
        else:
            email_index[email].append(i)

        # Phone checks
        if phone and not E164_PATTERN.match(phone):
            invalid_phone.append({
                'row': i + 1,
                'phone_original': phone_raw,
                'phone_normalized': phone,
                'name': f"{first_name} {last_name}".strip(),
                'issue': 'Phone not in E.164 format'
            })
            issues.append('invalid_phone')
        elif phone:
            phone_index[phone].append(i)

        # MENA detection
        if phone:
            is_mena, country, is_gulf = detect_mena(phone)
            if is_mena:
                mena_contacts.append({
                    'row': i + 1,
                    'name': f"{first_name} {last_name}".strip(),
                    'phone': phone,
                    'country': country,
                    'is_gulf': is_gulf,
                    'whatsapp_eligible': is_gulf,
                    'suggested_tags': [
                        'channel:whatsapp' if is_gulf else 'channel:sms',
                        f'channel:email' if email else ''
                    ]
                })

        # Track for ready-to-import
        contact['_row'] = i + 1
        contact['_issues'] = issues
        contact['_phone_normalized'] = phone
        contact['_email_normalized'] = email

    # Find in-file duplicates (emails)
    for email, indices in email_index.items():
        if len(indices) > 1:
            dup_group = {
                'email': email,
                'occurrences': len(indices),
                'rows': [i + 1 for i in indices],
                'contacts': [
                    {
                        'row': i + 1,
                        'name': f"{contacts[i].get('first_name', '')} {contacts[i].get('last_name', '')}".strip(),
                        'company': contacts[i].get('company', '')
                    }
                    for i in indices
                ],
                'recommendation': 'Merge before import — keep the most complete record'
            }
            duplicates_within_file.append(dup_group)

    # Find in-file duplicates (phones)
    for phone, indices in phone_index.items():
        if len(indices) > 1:
            # Check if already caught by email dedup
            emails = set()
            for i in indices:
                email = (contacts[i].get('email') or '').strip().lower()
                if email:
                    emails.add(email)

            # Only flag if these are different emails sharing a phone
            if len(emails) > 1 or len(emails) == 0:
                dup_group = {
                    'phone': phone,
                    'occurrences': len(indices),
                    'rows': [i + 1 for i in indices],
                    'contacts': [
                        {
                            'row': i + 1,
                            'name': f"{contacts[i].get('first_name', '')} {contacts[i].get('last_name', '')}".strip(),
                            'email': (contacts[i].get('email') or '').strip()
                        }
                        for i in indices
                    ],
                    'recommendation': 'Same phone, different emails — verify if same person'
                }
                duplicates_within_file.append(dup_group)

    # Build ready-to-import list (contacts with no issues)
    dup_rows = set()
    for dup in duplicates_within_file:
        for row in dup['rows'][1:]:  # Keep first occurrence
            dup_rows.add(row)

    for contact in contacts:
        if not contact['_issues'] and contact['_row'] not in dup_rows:
            clean_contact = {k: v for k, v in contact.items() if not k.startswith('_')}
            clean_contact['phone'] = contact['_phone_normalized']
            clean_contact['email'] = contact['_email_normalized']
            ready_to_import.append(clean_contact)

    # Summary
    summary = {
        'total_contacts': len(contacts),
        'ready_to_import': len(ready_to_import),
        'duplicates_found': len(duplicates_within_file),
        'missing_email': len(missing_email),
        'invalid_phone': len(invalid_phone),
        'invalid_email': len(invalid_email),
        'mena_contacts': len(mena_contacts),
        'gulf_whatsapp_eligible': sum(1 for m in mena_contacts if m['whatsapp_eligible']),
        'recommendations': []
    }

    if duplicates_within_file:
        summary['recommendations'].append(
            f"Resolve {len(duplicates_within_file)} duplicate groups before import"
        )
    if missing_email:
        summary['recommendations'].append(
            f"{len(missing_email)} contacts have no email — dedup by phone or skip"
        )
    if invalid_phone:
        summary['recommendations'].append(
            f"Fix {len(invalid_phone)} phone numbers to E.164 format before import"
        )
    if mena_contacts:
        gulf_count = sum(1 for m in mena_contacts if m['whatsapp_eligible'])
        summary['recommendations'].append(
            f"Auto-tag {gulf_count} Gulf contacts with channel:whatsapp"
        )

    return {
        'generated_at': datetime.now().isoformat(),
        'summary': summary,
        'duplicates_within_file': duplicates_within_file,
        'missing_email': missing_email,
        'invalid_phone': invalid_phone,
        'invalid_email': invalid_email if invalid_email else [],
        'mena_contacts': mena_contacts,
        'ready_to_import': ready_to_import
    }


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = None

    if '--output' in sys.argv:
        idx = sys.argv.index('--output')
        if idx + 1 < len(sys.argv):
            output_file = sys.argv[idx + 1]

    if not os.path.exists(input_file):
        print(f"Error: File not found: {input_file}")
        sys.exit(1)

    print(f"Loading contacts from {input_file}...")
    contacts = load_contacts(input_file)
    print(f"Loaded {len(contacts)} contacts")

    print("Running dedup check...")
    report = run_dedup_check(contacts)

    # Print summary
    s = report['summary']
    print(f"\n{'='*50}")
    print(f"DEDUP REPORT SUMMARY")
    print(f"{'='*50}")
    print(f"Total contacts:          {s['total_contacts']}")
    print(f"Ready to import:         {s['ready_to_import']}")
    print(f"Duplicates found:        {s['duplicates_found']}")
    print(f"Missing email:           {s['missing_email']}")
    print(f"Invalid phone:           {s['invalid_phone']}")
    print(f"MENA contacts:           {s['mena_contacts']}")
    print(f"WhatsApp eligible:       {s['gulf_whatsapp_eligible']}")
    print(f"{'='*50}")

    if s['recommendations']:
        print("\nRecommendations:")
        for rec in s['recommendations']:
            print(f"  → {rec}")

    if output_file:
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(report, f, indent=2, ensure_ascii=False)
        print(f"\nFull report saved to: {output_file}")
    else:
        print("\nTip: Use --output report.json to save the full report")


if __name__ == '__main__':
    main()
