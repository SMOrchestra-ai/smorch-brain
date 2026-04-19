#!/usr/bin/env python3
"""
SOP Effectiveness Metrics — weekly GitHub PR analysis with history + trends.

What it measures in the last 7 days across all active SMOrchestra repos:
  - Total PRs opened
  - % with handover brief attached (SOP-13 adoption)
  - % with docs/qa-scores/ file changes (SOP-02 adoption)
  - % merged
  - Per-repo PR count

Outputs to stdout + appends to historical CSV + sends Telegram digest.

Run weekly (Sundays 9pm Dubai / 17:00 UTC):
  0 17 * * 0 python3 /Users/mamounalamouri/Desktop/cowork-workspace/CodingProjects/smorch-brain/scripts/sop-effectiveness-metrics.py >> ~/Library/Logs/sop-metrics.log 2>&1

Env:
  TELEGRAM_BOT_TOKEN, TELEGRAM_CHAT_ID — send digest
  GITHUB_TOKEN — for higher rate limits (optional; uses gh CLI auth by default)
"""
import os, json, subprocess, csv, sys
from datetime import datetime, timedelta, timezone
from pathlib import Path

BRAIN = Path(os.environ.get('BRAIN', str(Path.home() / 'Desktop/cowork-workspace/CodingProjects/smorch-brain')))
HISTORY_CSV = BRAIN / 'canonical' / 'sop-metrics-history.csv'
TELEGRAM_BOT_TOKEN = os.environ.get('TELEGRAM_BOT_TOKEN', '')
TELEGRAM_CHAT_ID = os.environ.get('TELEGRAM_CHAT_ID', '311453473')

REPOS = [
    'SMOrchestra-ai/eo-mena',
    'SMOrchestra-ai/EO-Scorecard-Platform',
    'SMOrchestra-ai/digital-revenue-score',
    'SMOrchestra-ai/gtm-fitness-scorecard',
    'SMOrchestra-ai/Signal-Sales-Engine',
    'SMOrchestra-ai/content-automation',
    'SMOrchestra-ai/SaaSFast',
    'SMOrchestra-ai/smorch-brain',
    'SMOrchestra-ai/smorchestra-web',
    'SMOrchestra-ai/contabo-mcp-server',
]

def gh(cmd):
    """Call gh CLI, return stdout."""
    r = subprocess.run(['gh'] + cmd, capture_output=True, text=True)
    return r.stdout

def prs_last_7_days(repo):
    """Get PRs created in last 7 days."""
    out = gh(['pr', 'list', '--repo', repo, '--state', 'all', '--limit', '100',
              '--json', 'number,title,body,state,mergedAt,createdAt,files'])
    try:
        prs = json.loads(out) if out else []
    except Exception:
        return []
    week_ago = datetime.now(timezone.utc) - timedelta(days=7)
    result = []
    for p in prs:
        try:
            created = datetime.fromisoformat(p['createdAt'].replace('Z', '+00:00'))
            if created > week_ago:
                result.append(p)
        except Exception:
            pass
    return result

def has_handover_brief(pr):
    body = (pr.get('body') or '').lower()
    return any(k in body for k in ['handover', 'lana-handover', 'lana brief', '## 5-hat', 'composite:'])

def has_score_run(pr):
    files = pr.get('files', []) or []
    if not isinstance(files, list):
        return False
    for f in files:
        path = f.get('path', '') if isinstance(f, dict) else str(f)
        if 'qa-scores/' in path:
            return True
    return False

def was_merged(pr):
    return bool(pr.get('mergedAt'))

def pct(a, b):
    return f'{100 * a / b:.0f}%' if b else 'N/A'

def append_history(snapshot):
    """Append this run's snapshot to history CSV for trend tracking."""
    HISTORY_CSV.parent.mkdir(parents=True, exist_ok=True)
    new_file = not HISTORY_CSV.exists()
    with open(HISTORY_CSV, 'a', newline='') as f:
        w = csv.DictWriter(f, fieldnames=['date', 'total_prs', 'with_handover_pct', 'with_score_pct', 'merged_pct', 'repos_active'])
        if new_file:
            w.writeheader()
        w.writerow(snapshot)

def load_last_snapshot():
    """Read the previous snapshot for week-over-week delta."""
    if not HISTORY_CSV.exists():
        return None
    with open(HISTORY_CSV) as f:
        rows = list(csv.DictReader(f))
    if len(rows) < 2:  # need at least one prior row
        return None
    return rows[-2]

def main():
    total = 0
    with_handover = 0
    with_score = 0
    merged = 0
    per_repo = {}

    for repo in REPOS:
        prs = prs_last_7_days(repo)
        per_repo[repo] = len(prs)
        for pr in prs:
            total += 1
            if has_handover_brief(pr): with_handover += 1
            if has_score_run(pr): with_score += 1
            if was_merged(pr): merged += 1

    repos_active = sum(1 for n in per_repo.values() if n > 0)
    date = datetime.now().strftime('%Y-%m-%d')

    snapshot = {
        'date': date,
        'total_prs': total,
        'with_handover_pct': 100 * with_handover / total if total else 0,
        'with_score_pct': 100 * with_score / total if total else 0,
        'merged_pct': 100 * merged / total if total else 0,
        'repos_active': repos_active,
    }

    append_history(snapshot)

    # Compute week-over-week delta
    prev = load_last_snapshot()
    delta = {}
    if prev:
        try:
            delta = {
                'total_prs': total - int(prev['total_prs']),
                'with_handover_pct': snapshot['with_handover_pct'] - float(prev['with_handover_pct']),
                'with_score_pct': snapshot['with_score_pct'] - float(prev['with_score_pct']),
                'merged_pct': snapshot['merged_pct'] - float(prev['merged_pct']),
            }
        except Exception:
            pass

    def d(key, unit=''):
        if not delta or key not in delta:
            return ''
        v = delta[key]
        sign = '+' if v >= 0 else ''
        return f' ({sign}{v:.0f}{unit})'

    # Build report
    report = [
        f'📊 SOP Adoption Metrics — week ending {date}',
        f'',
        f'Last 7 days across {len(REPOS)} repos',
        f'',
        f'Total PRs: {total}{d("total_prs")}',
        f'Merged: {merged} ({pct(merged, total)}{d("merged_pct", "pp")})',
        f'With handover brief (SOP-13): {with_handover} ({pct(with_handover, total)}{d("with_handover_pct", "pp")})',
        f'With /score-project run (SOP-02): {with_score} ({pct(with_score, total)}{d("with_score_pct", "pp")})',
        f'Active repos: {repos_active}/{len(REPOS)}',
        f'',
        f'Adoption target: 80%+ on handover, 90%+ on score-project',
    ]

    if total > 0:
        handover_pct = 100 * with_handover / total
        score_pct = 100 * with_score / total
        if score_pct < 50:
            report.append(f'')
            report.append(f'⚠ /score-project adoption below 50%. Enforce via independent QA agent on smo-eo-qa (SMO-220).')
        if handover_pct < 50:
            report.append(f'⚠ Handover brief adoption below 50%. Remind engineers via SOP-13.')

    if per_repo:
        report.append(f'')
        report.append(f'Per-repo PR count:')
        for repo, count in sorted(per_repo.items(), key=lambda x: -x[1]):
            if count > 0:
                report.append(f'  {repo.split("/")[-1]}: {count}')

    msg = '\n'.join(report)
    print(msg)

    if TELEGRAM_BOT_TOKEN:
        subprocess.run([
            'curl', '-s', '-X', 'POST',
            f'https://api.telegram.org/bot{TELEGRAM_BOT_TOKEN}/sendMessage',
            '-d', f'chat_id={TELEGRAM_CHAT_ID}',
            '--data-urlencode', f'text={msg}',
        ], capture_output=True)

    return 0

if __name__ == '__main__':
    sys.exit(main())
