# Multi-Server Security + Health Audit — 2026-05-01

**Scope:** eo-prod (89.117.62.131) · eo-dev (84.247.172.113) · smo-prod (62.171.164.178) · smo-dev (62.171.165.57)
**Mode:** Read-only. No remediation applied. No services restarted. No installs.
**Run by:** Claude Code (smo-desktop) via SSH.
**Trigger:** User request — full malware + security + health sweep.
**Driver:** Post-perfctl hygiene (incident 2026-04-18) and pre-merge-freeze posture check.
**Raw evidence:** `docs/audits/raw/2026-05-01/<server>.txt` (one file per server).

---

## Executive Summary

**No active malware. No P0 findings. All 4 servers are operationally healthy.**

The post-perfctl hardening (UFW, fail2ban, key-only SSH, unattended-upgrades, perfctl-sentinel cron, infra-drift cron, env-backup cron, sync-from-github cron) is **uniformly deployed and running** across all 4 servers. Tailscale mesh is intact. Disk and RAM are healthy on every server. fail2ban has banned 58–194 brute-force attempts per server in steady state — working as intended.

Two **P1** items need a maintenance window: a pending kernel upgrade (6.8.0-110 → 6.8.0-111) on all 4 servers, and the `kmod`/`libkmod2` security patch lag on the two **prod** servers (the dev servers already auto-applied it 2026-05-01). A handful of **P2** items concern security drift between dev and prod (x11forwarding inconsistent, world-writable n8n data on smo-dev) and one stale post-incident archive on eo-prod still holding `.env` files.

### 4×6 Pass / Warn / Fail matrix

| Server | Health | Posture | Malware | CVE | Drift | Secrets |
|---|---|---|---|---|---|---|
| **eo-prod**   | ✅ pass | ⚠️ warn¹ | ✅ pass | ⚠️ warn² | ✅ pass | ⚠️ warn³ |
| **smo-prod**  | ✅ pass | ⚠️ warn¹ | ✅ pass | ⚠️ warn² | ✅ pass | ✅ pass |
| **smo-dev**   | ✅ pass | ⚠️ warn⁴ | ✅ pass | ✅ pass | ✅ pass | ✅ pass |
| **eo-dev**    | ⚠️ warn⁵ | ✅ pass | ✅ pass | ✅ pass | ✅ pass | ✅ pass |

¹ x11forwarding inconsistency or `permitrootlogin without-password` (Ubuntu default, key-only). ² kmod/libkmod2 security patch not yet auto-applied. ³ stale `_archive-2026-04-18` holds `.env` files; SSH host keys >90d. ⁴ 2.4 GB world-writable n8n SQLite. ⁵ no apps deployed (no PM2 processes, no /api/health responders).

### Counts

- **P0** (act now): **0**
- **P1** (act within 7 days, scheduled): **2**
- **P2** (act within 30 days): **5**
- **P3** (informational / nice-to-have): **5**

No `/smo-incident` SEV2 ticket required.

---

## Per-server detail

### Server: eo-prod (89.117.62.131 / Tailscale 100.89.148.62)

**Hostname:** `vmi3051702` · **OS:** Ubuntu 24.04.4 LTS · **Kernel:** 6.8.0-110-generic · **Uptime:** 7d 13h
**Apps (PM2):** eo-scoring, eo-main, eo-scorecard, saasfast-page-online (all online, 0 restarts except saasfast 2)
**Loopback /api/health:** 127.0.0.1:3000 ✅ 5678 (n8n) ✅ 8000 ✅
**Postgres:** local PG running, 5432 + 54329, accepting connections ✅
**Disk:** 64% used (`/dev/sda1` 96G total, 35G free) — well below threshold.
**Tailscale:** all 6 peers visible, IP matches expected `100.89.148.62` ✅

**Posture (B):**
- ufw active, default-deny inbound, only `22/80/443` + `tailscale0` exposed ✅
- fail2ban running, sshd jail, 58 total bans (currently 0) ✅
- sshd config: `permitrootlogin without-password`, `passwordauthentication no`, `pubkeyauthentication yes`, `x11forwarding no` ✅
- unattended-upgrades active, last successful run 2026-05-01 14:06 ✅
- World-writable scan: clean (60s bounded, no findings) ✅
- Kernel 6.8.0-110, **6.8.0-111 pending** ⚠️

**Malware (C):**
- No masquerade processes (no exe in /tmp, /var/tmp, /dev/shm) ✅
- No perfctl-class IOCs — only legit `/tmp/.X11-unix` + `/tmp/.XIM-unix` dirs and the defensive `perfctl-sentinel.sh` cron ✅
- No `/etc/ld.so.preload`, no LD_PRELOAD env ✅
- Cron: rich set of legitimate SMO operational scripts (queue-processor, monitor-dispatch, perfctl-sentinel, infra-drift, app-drift, sync-from-github, backup-n8n, backup-env) ✅
- `/root/.ssh/authorized_keys`: **5 keys** — `contabo-mcp`, `mamounalamouri@Mamouns-MacBook-Pro.local`, `node@ff29fb445d3b` (Docker container), `github-actions-deploy@smorchestra.ai`, `lana@lana-desktop-2026`. All identifiable. ✅
- `/home/mamoun/.ssh/authorized_keys`: 1 key (`contabo-mcp`). ✅
- Recent /etc changes (30d): all benign — apt cache, letsencrypt renewals, sshd_config.pre-hardening backup, ufw rules, openclaw service definitions. ✅
- 2 non-system users (`sulaiman` UID 1000, `mamoun` UID 1001), both in sudo group. Documented. ✅

**CVE (D):**
- 2 pending security upgrades: `kmod/noble-security 31+20240202-2ubuntu7.2` and `libkmod2/noble-security 31+20240202-2ubuntu7.2` ⚠️
- debsecan not installed (P3 — recommend adding for ongoing CVE coverage).

**Drift (E):** infra-drift + app-drift crons running hourly ✅. No PM2 restart anomalies ✅.

**Secrets (F):**
- Active `.env.local` files in `/opt/apps/eo-mena` (17d old) and `/opt/apps/saasfast-page-online` (3d old). `backup-env.sh` runs nightly at 02:30 — covered.
- ⚠️ **Stale archive `/root/_archive-2026-04-18/dirs/scrapmfast/`** still on disk: 4 `.env` files, 74–92 days old, contain real ScrapMfast secrets. Post-perfctl archive should be evacuated to offsite storage and deleted from server.
- ⚠️ SSH host keys `/etc/ssh/ssh_host_*` from **2026-01-29** = **92 days old**, just over SOP-16 90-day rotation threshold.
- Root SSH keys: `id_ed25519` 2026-03-15 (47d), `id_eo_prod` 2026-04-23 (8d). Within policy ✅.

---

### Server: smo-prod (62.171.164.178 / Tailscale 100.108.44.127)

**Hostname:** `vmi3071951` · **OS:** Ubuntu 24.04.4 LTS · **Kernel:** 6.8.0-110-generic · **Uptime:** 8d 23h
**Apps (PM2):** digital-revenue-score, gtm-fitness-scorecard, sse-backend (all online; **sse-backend has 10 restarts** — informational)
**Loopback /api/health:** 127.0.0.1:5678 ✅ 6001 (sse-backend) ✅
**Postgres:** **no local PG (uses Supabase)** — `/var/run/postgresql:5432 - no response` is expected and correct ✅
**Disk:** 16% used (`/dev/sda1` 193G total, 163G free) ✅

**Posture (B):**
- ufw active, default-deny, exact same rules as eo-prod ✅
- fail2ban: **96 total bans, currently 1 banned (199.195.254.215), 7,624 total failed attempts** — working hard, working correctly ✅
- sshd: `permitrootlogin without-password`, `passwordauth no`, **`x11forwarding yes`** ⚠️ (drift vs eo-prod which has `no`)
- unattended-upgrades active, last run 2026-05-01 10:21 (pulled openssh-{client,server,sftp-server} on 2026-05-01 06:56) ✅
- World-writable scan: clean ✅
- Kernel 6.8.0-110, **6.8.0-111 pending** ⚠️
- Listening ports: clean — only nginx (80/443), sshd (22), n8n docker-proxy (5678), tailscale, sse-backend (6001), Next.js servers (3100/3200/3401), one docker-proxy on 3300/loopback. ✅

**Malware (C):**
- No masquerade, no perfctl IOCs, no LD_PRELOAD ✅
- Cron: lean — only the post-perfctl auto-sync set (perfctl-sentinel, infra-drift, app-drift, sync-from-github, backup-n8n, backup-env). ✅
- `/root/.ssh/authorized_keys`: **4 keys** — `mamounalamouri@…`, `lana@lana-desktop-2026`, `eo-prod-server`, `smo-brain-server`. All identifiable as cross-server automation keys. ✅
- Recent /etc changes (30d): post-perfctl re-provision artifacts (cloud-init, ufw, fstab, pm2-root.service, letsencrypt for sse/contentengine/flows/score/flow.smorchestra.ai), all expected. ✅
- 0 non-system users; `sudo` group empty (root-only operations). ✅

**CVE (D):** Same 2 pending: `kmod` + `libkmod2`. ⚠️ Same kernel pending. ⚠️

**Drift (E):** crons running, no PM2 anomalies (sse-backend 10 restarts is below the 50 threshold but worth noting). ✅

**Secrets (F):**
- Active `.env` files: `signal-sales-engine/ScrapMfast/.env` (3d), `signal-sales-engine/scrapmfast_frontend/.env.production` (3d), `gtm-fitness-scorecard/.env.local` (12d), `digital-revenue-score/.env.local` (12d), `content-automation/.env` (3d). All fresh. ✅
- One `.env.bak.20260428-072741` snapshot in ScrapMfast (3d old) — orderly backup pattern.
- SSH host keys from **2026-04-18 22:45** (post-perfctl re-provision) — 13d old, well within 90d ✅.

---

### Server: smo-dev (62.171.165.57 / Tailscale 100.83.242.99)

**Hostname:** `smo-dev` · **OS:** Ubuntu 24.04.4 LTS · **Kernel:** 6.8.0-110-generic · **Uptime:** 8d 23h
**Apps (PM2):** eo-dashboard (online, **19 restarts** — elevated but below 50 threshold)
**Loopback /api/health:** 127.0.0.1:3000 → **HTTP 404** (eo-dashboard does not expose `/api/health`) ⚠️ P3
**Disk:** 13% used ✅

**Posture (B):**
- ufw default-deny ✅
- fail2ban: **194 total bans, currently 2 banned (45.148.10.183, 106.75.88.44), 12,057 total failed** — staging server is the brute-force magnet ✅
- sshd: same as smo-prod, **`x11forwarding yes`** ⚠️
- unattended-upgrades active, **already pulled `kmod libkmod2 openssh-{client,server,sftp-server}` 2026-05-01 06:17** ✅ (proves auto-patching path works — the same patch lag on prod servers needs investigation)
- Kernel 6.8.0-110, 6.8.0-111 pending ⚠️
- ⚠️ **World-writable scan flagged 2.4 GB n8n SQLite + node_modules tree:**
  - `/opt/n8n/n8n_data/database.sqlite` (2.4 GB, mode `-rwxrwxrwx`, owner UID 1000)
  - 36+ files under `/opt/n8n/n8n_data/nodes/node_modules/@blotato/n8n-nodes-blotato/` (mode 777)
  - 30+ files under `/opt/n8n/n8n_data/nodes/node_modules/n8n-nodes-comfyui/` (mode 777)
  These are inside the Docker volume and only writable by users on the host with read access to `/opt/n8n/n8n_data`. The risk is local privilege escalation if any other process ran as a non-root user — there are none. Still: tighten to `660`/`770` per the n8n container UID 1000 mapping.

**Malware (C):**
- No masquerade, no perfctl IOCs, no LD_PRELOAD ✅
- Same cron set as smo-prod ✅
- `/root/.ssh/authorized_keys`: same 4 keys as smo-prod (mamoun, lana, eo-prod-server, smo-brain-server) ✅
- 0 non-system users, sudo group empty ✅

**CVE (D):** No pending security upgrades (`apt list --upgradable` is empty for security). ✅

**Drift (E):** crons running ✅.

**Secrets (F):** `eo-dashboard/.env.local` (3d), `.env.test` (6d), `.env.local.bak.1777319019` (3d) — orderly. SSH host keys 2026-04-18 (13d) ✅.

---

### Server: eo-dev (84.247.172.113 / Tailscale 100.99.145.22)

**Hostname:** `eo-dev` · **OS:** Ubuntu 24.04.4 LTS · **Kernel:** 6.8.0-110-generic · **Uptime:** 7d 13h
**Apps (PM2):** **none** ⚠️ — `pm2 list` returned empty.
**Loopback /api/health:** **no responses on any common port** ⚠️ — only nginx and sshd listening.
**Disk:** 7% used ✅

This is consistent with eo-dev being **freshly renamed from smo-eo-qa on 2026-04-29** per `~/.claude/CLAUDE.md`. Apps not yet deployed. **Confirm with user whether deployment is intentional.**

**Posture (B):** ufw + fail2ban + unattended-upgrades all active ✅. **`x11forwarding yes`** ⚠️. Kernel 6.8.0-111 pending ⚠️. Kmod patches already auto-applied 2026-05-01 06:29 ✅.

⚠️ World-writable hits: `/root/.bun/install/cache/*` files (mode 666, ~50 hits) — the bun cache writes with permissive perms. Mostly informational since these are root-owned and under /root. Recommend `chmod -R go-w /root/.bun/install/cache` and report upstream to bun.

**Malware (C):** Clean across the board. `/root/.ssh/authorized_keys` minimal: 2 keys (mamoun, lana). ✅

**CVE (D):** No pending security upgrades ✅. Kernel pending ⚠️.

**Drift (E):** infra-drift cron running ✅. No PM2 anomalies (no PM2 apps). ✅

**Secrets (F):** No app `.env` files (no apps deployed). Only system templates. SSH host keys 2026-04-18 (13d) ✅.

---

## Cross-server divergence

| Dimension | eo-prod | smo-prod | smo-dev | eo-dev | Notes |
|---|---|---|---|---|---|
| `x11forwarding` | **no** ✅ | yes ⚠️ | yes ⚠️ | yes ⚠️ | Standardize to `no` — no SMO server runs X clients. |
| `kmod`/`libkmod2` security patch | pending ⚠️ | pending ⚠️ | applied ✅ | applied ✅ | Investigate why prod auto-update lagged dev by 12+ hours. |
| Kernel 6.8.0-111 | pending | pending | pending | pending | All 4 need scheduled reboot. |
| SSH host keys age | **92d** ⚠️ | 13d ✅ | 13d ✅ | 13d ✅ | eo-prod overdue per SOP-16 90d. |
| `/root/.ssh/authorized_keys` count | 5 | 4 | 4 | 2 | eo-prod has extra `node@docker` + `github-actions-deploy`; eo-dev intentionally lean. |
| Tailscale | ✅ all peers | ✅ all peers | ✅ all peers | ✅ all peers | Mesh healthy. |
| Local Postgres | local PG ✅ | Supabase only ✅ | Supabase only ✅ | Supabase only ✅ | Documented in CLAUDE.md. |
| post-perfctl cron set | ✅ all 6 | ✅ all 6 | ✅ all 5 | ✅ all 5 | smo-prod and eo-prod have additional `app-drift.sh`. |

---

## Action list

### P1 (schedule within 7 days)

**P1-1 — Apply pending kernel + reboot all 4 servers (rolling)**
Affected: eo-prod, smo-prod, smo-dev, eo-dev.
```bash
# Run per server during a maintenance window:
ssh <server> 'apt update && apt upgrade -y && reboot'
# Stagger 30 min between servers; verify /api/health after each.
```
**Risk if skipped:** running an outdated kernel against newly-disclosed kernel CVEs.

**P1-2 — Investigate `kmod`/`libkmod2` patch lag on prod servers**
Affected: eo-prod, smo-prod (both still showing pending; both dev servers auto-applied 2026-05-01 06:17–06:29).
```bash
# On each prod:
ssh <server> 'grep -i kmod /var/log/unattended-upgrades/unattended-upgrades.log'
ssh <server> 'cat /etc/apt/apt.conf.d/50unattended-upgrades | grep -i blacklist'
# Likely cause: package held by `apt-mark hold`, or in unattended-upgrades blacklist.
```
**Risk if skipped:** prod missing security fixes that dev already has.

### P2 (schedule within 30 days)

**P2-1 — Standardize `x11forwarding no` across smo-prod, smo-dev, eo-dev**
```bash
# Per server:
sed -i 's/^X11Forwarding yes/X11Forwarding no/' /etc/ssh/sshd_config
sshd -t && systemctl reload ssh
```

**P2-2 — Tighten n8n data perms on smo-dev (and check other n8n hosts)**
```bash
# On smo-dev:
chmod -R go-w /opt/n8n/n8n_data
chmod 600 /opt/n8n/n8n_data/database.sqlite
# Verify n8n container still works (UID 1000 needs read+write to its volume).
```

**P2-3 — Evacuate stale archive on eo-prod**
`/root/_archive-2026-04-18/dirs/scrapmfast/` contains 4 `.env` files with secrets, 74–92 days old.
```bash
# 1. Verify backup-env.sh nightly cron has captured these — check Contabo Object Storage / 1Password
# 2. Encrypt + move offsite: tar czf - /root/_archive-2026-04-18 | age -r <pubkey> > archive-2026-04-18.tar.gz.age
# 3. After offsite confirmed: rm -rf /root/_archive-2026-04-18
```

**P2-4 — Rotate eo-prod SSH host keys (92d, exceeds SOP-16 90d)**
```bash
# Maintenance window required (will trigger known_hosts mismatch on every client):
ssh-keygen -A  # regenerate /etc/ssh/ssh_host_*
systemctl restart ssh
# Coordinate with Lana + smo-desktop + smo-prod + smo-dev to update known_hosts.
```

**P2-5 — Tighten `permitrootlogin` from `without-password` to `prohibit-password` on all 4**
Functionally equivalent (both block password auth) but `prohibit-password` is the unambiguous modern form. Or — better — disable root SSH entirely and use sudo via `mamoun`/`sulaiman` users. Currently only eo-prod has non-root sudo users provisioned.

### P3 (informational)

**P3-1 — Deploy apps to eo-dev** (or document that it's intentionally idle until needed). PM2 list is empty; no /api/health responders.
**P3-2 — Add `/api/health` to smo-dev's `eo-dashboard` app** — currently returns 404. Health check value is zero without it.
**P3-3 — Install `debsecan` on all 4 servers** for ongoing CVE coverage. Read-only audit run could not auto-install.
**P3-4 — Fix nginx warnings** on eo-prod (deprecated `http2` listen syntax in `/etc/nginx/sites-enabled/saasfast-page-online`) and smo-prod (`protocol options redefined for 62.171.164.178:443` in `/etc/nginx/sites-enabled/sse`).
**P3-5 — Review `sse-backend` (smo-prod) and `eo-dashboard` (smo-dev) restart counts** (10 and 19 respectively). Below 50 threshold but elevated; check `pm2 logs <app>` for crash patterns.

---

## What worked well (positive signal)

- Post-perfctl hardening is **uniformly deployed**. All 4 servers run perfctl-sentinel, infra-drift, app-drift (where applicable), sync-from-github, backup-n8n, backup-env crons.
- fail2ban is **actively defending** every server — 58 to 194 bans accumulated, currently 0–2 banned in real time.
- UFW default-deny + tailscale-mesh + key-only SSH = textbook posture. No public-exposed databases, redis, or app ports beyond nginx.
- `/etc/ld.so.preload` empty on every server (the perfctl injection vector). `/tmp/.X*-unix` directories are legitimate `drwxrwxrwt root:root` — not the malware-style files.
- No masquerade processes (no exe in /tmp, /var/tmp, /dev/shm) on any server.
- Tailscale mesh complete and stable.

---

## Verification (this audit)

Each finding above is grounded in a specific section of the raw evidence:

| Finding | Raw file | Section |
|---|---|---|
| kmod/libkmod2 pending on eo-prod | `raw/2026-05-01/eo-prod.txt` | D1 (line 342–343) |
| kmod/libkmod2 already applied on smo-dev | `raw/2026-05-01/smo-dev.txt` | B4 (line 110) |
| smo-dev world-writable n8n SQLite | `raw/2026-05-01/smo-dev.txt` | B5 (line 115) |
| eo-prod stale archive `.env` files | `raw/2026-05-01/eo-prod.txt` | F1 (lines 393–396) |
| eo-prod SSH host keys age | `raw/2026-05-01/eo-prod.txt` | F2 (lines 404–406) |
| x11forwarding divergence | All 4 files | B3 |
| No perfctl IOCs anywhere | All 4 files | C2 |

Anyone can re-run a single check with the exact bounded command from `/tmp/sse-audit.sh` (saved on smo-desktop).

---

## Next steps

1. **User decides** on P1-1 maintenance window (rolling reboot of 4 servers, 30-min stagger). Suggest: this weekend.
2. **User decides** on P2-3 (stale archive evacuation) — needs offsite-storage verification first per **L-001**.
3. After P1/P2 fixes, re-run this audit and diff: same script piped via `ssh-manager` → new raw/ folder → diff.
4. Consider scheduling this as a **weekly cron** alongside the existing `smorch-weekly-architecture-audit`.

— end of report —
