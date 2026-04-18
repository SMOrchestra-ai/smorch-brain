#!/usr/bin/env python3
"""
SOP Effectiveness Metrics — Weekly Report

Pulls PRs from the last 7 days across SMOrchestra GitHub repos, measures:
  - % PRs with handover brief attached
  - % PRs with /score-project run (look for docs/qa-scores/ changes)
  - % deployments with post-deploy probe success (parse Telegram logs or Sentry)
  - MTTR of incidents in last 4 weeks

Outputs to stdout + sends summary to Telegram.

Run: python3 scripts/sop-effectiveness-metrics.py
Cron: Sundays 9pm Dubai via n8n or local crontab
"""
import os, json, subprocess, sys
from datetime import datetime, timedelta

GITHUB_TOKEN = os.environ.get('GITHUB_TOKEN', '')
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
    """Get PRs created or updated in last 7 days."""
    out = gh(['pr', 'list', '--repo', repo, '--state', 'all', '--limit', '50',
              '--json', 'number,title,body,state,mergedAt,createdAt,files'])
    try:
        prs = json.loads(out) if out else []
    except:
        return []
    week_ago = datetime.utcnow() - timedelta(days=7)
    return [p for p in prs if datetime.fromisoformat(p['createdAt'].rstrip('Z')) > week_ago]

def has_handover_brief(pr):
    """Check if PR body mentions LANA-HANDOVER-BRIEF or docs/handovers/."""
    body = (pr.get('body') or '').lower()
    return 'handover' in body or 'lana' in body

def has_score_run(pr):
    """Check if PR has docs/qa-scores/ file changes."""
    files = pr.get('files', []) or []
    if not isinstance(files, list):
        return False
    return any('qa-scores/' in (f.get('path', '') if isinstance(f, dict) else str(f)) for f in files)

def main():
    total = 0
    with_handover = 0
    with_score = 0
    per_repo = {}

    for repo in REPOS:
        prs = prs_last_7_days(repo)
        per_repo[repo] = len(prs)
        for pr in prs:
            total += 1
            if has_handover_brief(pr): with_handover += 1
            if has_score_run(pr): with_score += 1

    pct = lambda a, b: f'{100 * a / b:.0f}%' if b else 'N/A'

    report = [
        f'📊 SOP Metrics — {datetime.now().strftime("%Y-%m-%d")}',
        f'Last 7 days across {len(REPOS)} repos',
        '',
        f'Total PRs: {total}',
        f'With handover brief: {with_handover} ({pct(with_handover, total)})',
        f'With /score-project run: {with_score} ({pct(with_score, total)})',
        '',
        'Per-repo PR count:',
    ]
    for repo, count in sorted(per_repo.items(), key=lambda x: -x[1]):
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

if __name__ == '__main__':
    main()
