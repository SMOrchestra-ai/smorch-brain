#!/usr/bin/env python3
"""
Skill drift detector — compares skill hashes on each machine to canonical manifest.

Run: python3 scripts/check-skill-drift.py
Cron: every 6h

Exits 0 if no drift, 1 if drift. Sends Telegram alert on drift.
"""
import hashlib, json, os, subprocess, sys
from pathlib import Path

BRAIN = Path(os.environ.get('BRAIN', '/Users/mamounalamouri/Desktop/cowork-workspace/CodingProjects/smorch-brain'))
MANIFEST = BRAIN / 'canonical' / 'skills-manifest.json'
BOT_TOKEN = os.environ.get('TELEGRAM_BOT_TOKEN', '')
CHAT_ID = os.environ.get('TELEGRAM_CHAT_ID', '311453473')

MACHINES = {
    'local': None,  # local filesystem
    'smo-dev': '100.117.35.19',
    'smo-prod': '100.84.76.35',
    'eo-prod': '100.89.148.62',
}

def hash_remote_skill(ip, remote_path):
    """Hash a skill dir on a remote machine."""
    cmd = f"cd {remote_path} 2>/dev/null && find . -type f -not -path '*/node_modules/*' -not -path '*/.git/*' -not -name '.DS_Store' | sort | xargs sha256sum 2>/dev/null | sha256sum | awk '{{print $1}}' | head -c 16"
    try:
        r = subprocess.run(['ssh', '-o', 'ConnectTimeout=10', f'root@{ip}', cmd], capture_output=True, text=True, timeout=30)
        return r.stdout.strip() or None
    except:
        return None

def hash_local_skill(path):
    """Hash a local skill dir the same way as manifest generator."""
    h = hashlib.sha256()
    if not path.exists():
        return None
    for root, dirs, files in os.walk(path):
        dirs.sort()
        for fname in sorted(files):
            if fname.startswith('.') or fname == 'node_modules':
                continue
            fpath = Path(root) / fname
            try:
                with open(fpath, 'rb') as f:
                    h.update(fpath.name.encode())
                    h.update(f.read())
            except:
                pass
    return h.hexdigest()[:16]

def main():
    with open(MANIFEST) as f:
        manifest = json.load(f)

    drift = []
    checked = 0

    # Check local
    skills_dir = Path.home() / '.claude' / 'skills'
    for plugin_name, info in manifest['plugins'].items():
        # The canonical comes from smorch-brain/plugins/, local has them in ~/.claude/skills/ via symlinks or direct
        # Actually skills on local are in ~/.claude/skills/ — not plugin-level. Skip plugin-level for local.
        pass

    # For each machine, check every skill from manifest
    for machine, ip in MACHINES.items():
        if ip is None:
            continue  # Skip local for now
        for skill_key, info in manifest['skills'].items():
            plugin = info['plugin']
            skill_name = skill_key.split('/')[-1]
            # Skills on servers live at /root/.claude/skills/{skill_name}/
            remote_path = f"/root/.claude/skills/{skill_name}"
            remote_hash = hash_remote_skill(ip, remote_path)
            checked += 1
            if remote_hash is None:
                drift.append(f"⚠️ {machine} {skill_name} — MISSING")
            elif remote_hash != info['hash']:
                # Servers get skills via rsync, so they may legitimately drift from smorch-brain/plugins/
                # We only alert on significant drift — for now, flag it
                drift.append(f"🚨 {machine} {skill_name} — DRIFT (got {remote_hash})")

    print(f"Checked {checked} skill instances across {len([m for m in MACHINES if MACHINES[m]])} machines")
    print(f"Drift entries: {len(drift)}")

    if drift:
        for d in drift[:20]:
            print(d)
        if len(drift) > 20:
            print(f"... and {len(drift) - 20} more")

    if drift and BOT_TOKEN:
        summary = f"🔔 Skill Drift — {len(drift)} issues\n" + "\n".join(drift[:10])
        subprocess.run([
            'curl', '-s', '-X', 'POST',
            f'https://api.telegram.org/bot{BOT_TOKEN}/sendMessage',
            '-d', f'chat_id={CHAT_ID}',
            '--data-urlencode', f'text={summary}',
        ], capture_output=True)

    sys.exit(1 if drift else 0)

if __name__ == '__main__':
    main()
