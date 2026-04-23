# Global Lessons — ~/.claude/lessons.md

**Scope:** cross-project rules Claude applies at every SMOrchestra session.
**Auto-loaded at SessionStart via `~/.claude/settings.json` hook.**
**Format per lesson:** trigger → rule → check → last-triggered.
**Last pruned:** 2026-04-21
**Last updated:** 2026-04-21 (L-009 added)

---

## Active lessons

### L-001 — Before any server rebuild/reinstall, back up .env.local files
- **Captured:** 2026-04-21
- **Trigger:** After rebuilding smo-dev post-perfctl malware, `.env.local` files for content-automation, Signal-Sales-Engine, and SaaSfast were gone. Had to chase GHL, Supabase, Postgres credentials for hours. User: "you were supposed to restore everything including n8n, you fucked things up."
- **Rule:** ANY server reinstall, rebuild, snapshot-restore, or clean-install workflow MUST include a pre-step that tar+encrypts every `/opt/apps/*/.env*` and `/root/{project}/.env*` file and pushes to secure storage (1Password, private backup repo, or Contabo object storage).
- **Check:** Engineering hat Q7 (secrets in .env) extended — Q7b: "is there a backup path for this .env.local?" Answer NO → Q7 caps at 5.
- **Enforcement:** `/smo-secrets --backup` command on every server before any destructive maintenance.
- **Last triggered:** 2026-04-21

### L-002 — Verify canonical app state before declaring rollout "complete"
- **Captured:** 2026-04-21
- **Trigger:** Declared "Phase 7 migration done" but smo-dev had no application code (content-automation, SSE, SaaSfast all missing). Only infra plugin (smorch-ops) was installed. User found gap days later: "we found nothing."
- **Rule:** Every server rollout completion claim MUST include the output of: (a) `ls /opt/apps/`, (b) `pm2 list --no-color | head`, (c) `docker compose ps` per app, (d) `curl /api/health` for every registered project. Missing = NOT complete.
- **Check:** `/smo-health` run at end of Phase 7, report attached to PR before declaring done.
- **Last triggered:** 2026-04-21

### L-003 — Apps live in /opt/apps/, never /root/
- **Captured:** 2026-04-21
- **Trigger:** Rsync'd SSE + SaaSfast to `/root/` instead of `/opt/apps/`, contradicting our own DevOps Manual §2 + server plan. User: "create things properly with right naming and folder structure. not random."
- **Rule:** Apps go in `/opt/apps/{kebab-case-name}/`. Tooling/clones go in `/root/`. Configs in `/opt/config/`. Logs in `/opt/logs/{app}/`. Backups in `/opt/backups/`. Naming is lowercase-hyphen only.
- **Check:** validate-plugins.sh extended to verify no `/root/*-{Repo,REPO,repo-Name,RepoName}/` app directories exist — only `/opt/apps/` for apps.
- **Last triggered:** 2026-04-21

### L-004 — Docker-compose apps are NOT PM2 apps
- **Captured:** 2026-04-21
- **Trigger:** Set up PM2 ecosystem for content-automation not realizing it has its own `docker-compose.yml` with postgres + runtime + gui + nginx. PM2 kept crash-looping. Wasted 30 min debugging before checking Dockerfile.
- **Rule:** Before creating/modifying PM2 ecosystem for a project, check for `docker-compose.yml` at project root. If present → use `docker compose up -d` path, NOT PM2. Document the decision in the project's `.smorch/project.json` under `deploy.orchestration: "docker-compose" | "pm2" | "systemd"`.
- **Check:** `/smo-deploy` reads `.smorch/project.json` `deploy.orchestration` before picking the deploy path.
- **Last triggered:** 2026-04-21

### L-005 — Port conflicts: system nginx vs docker-compose nginx
- **Captured:** 2026-04-21
- **Trigger:** content-automation's docker-compose includes an nginx container binding 0.0.0.0:80 — conflicted with the host's system nginx (serving testflow.smorchestra.ai). Wasted 15 min.
- **Rule:** When a docker-compose project includes nginx AND the host has system nginx running → remove the compose nginx service (`docker compose rm -sf nginx`), use system nginx as the single reverse-proxy layer. App containers bind `127.0.0.1:{port}` (localhost only), system nginx proxies.
- **Check:** `/smo-health` posture check: multiple nginx processes bound to :80 on same host → flag SEV3.
- **Last triggered:** 2026-04-21

### L-006 — Port ghosts survive docker restart
- **Captured:** 2026-04-21
- **Trigger:** Restarted Docker daemon cleanly (`systemctl restart docker`), but port 3301 was still "already in use" — no process showing in ss/lsof. Turned out to be leftover network endpoint state.
- **Rule:** When Docker complains about port bind after restart: (1) `docker network prune -f`, (2) `docker compose down && docker compose up -d`, (3) if still stuck, pick a different port (e.g., 3400/3401 instead of 3300/3301). Don't fight port ghosts when the port number is arbitrary.
- **Check:** deploy-pipeline skill: if binding fails twice, auto-offset port range by +100.
- **Last triggered:** 2026-04-21

### L-007 — Don't assume "already restored" without concrete evidence
- **Captured:** 2026-04-21
- **Trigger:** Assumed server rebuild restored n8n workflows — never verified. Actually they WERE preserved (volume mount survived), but I had no evidence until I ran `docker exec n8n n8n list:workflow`. "Looks fine" is not restoration confirmation.
- **Rule:** Post-rebuild verification must include: (a) list actual workflows/records by exec'ing into the running service, (b) hit `/api/health` for every app with expected JSON response, (c) compare to pre-rebuild snapshot if available.
- **Check:** drift-detector skill extended with `--post-rebuild` mode that runs all 3 checks + fails if any diverges.
- **Last triggered:** 2026-04-21

### L-008 — Plugin commands don't auto-discover from ~/.claude/plugins/
- **Captured:** 2026-04-20
- **Trigger:** Installed plugins by copying files to `~/.claude/plugins/smorch-dev/`. `/smo-*` commands didn't resolve even after Claude Code restart. Root cause: Claude Code uses marketplace registration model. Two bugs: (a) missing `.claude-plugin/marketplace.json` at repo root, (b) `plugin.json` had invalid `commands[]` + `skills[]` arrays (auto-discovered from folders).
- **Rule:** Plugin deploy path MUST be: `claude plugin marketplace add {org}/{repo}` then `claude plugin install {name}@{marketplace}`. Never cp/rsync plugin files directly. `plugin.json` schema: only `name`, `version`, `description`, `author`, `homepage`, `repository`, `license`, `keywords`. Folders `commands/` and `skills/*/SKILL.md` are auto-discovered.
- **Check:** validate-plugins.sh: fails if `commands[]` or `skills[]` arrays present in plugin.json.
- **Last triggered:** 2026-04-20

### L-009 — GitHub is the single point of truth. Always commit AND push. No excuses.
- **Captured:** 2026-04-21
- **Trigger:** Shipped a full v1.1.0 upgrade to `eo-microsaas-dev` (new skill, 8 modified files, 10 new files, version bump, CHANGELOG, rollback runbook, tests README, CLAUDE.md templates). Said "done" and moved on to plan the next thing. Nothing was committed, nothing was pushed. Local worktree held every change. User: "you always don't push and this usually lead to github drift. enforce this fucking rule." Correct. This is a recurring failure pattern, not a one-off.
- **Rule:** GitHub remote is the single authoritative source of truth for every SMOrchestra repo. Local worktrees, other machines, student machines, servers — all pull from there. A change that exists only in a local worktree is invisible work: it can be wiped by a machine failure, missed by Lana's sync cron, missed by the EO install.sh, and invites silent drift when the next session starts from stale `origin/main`.
  - **Default behavior:** at the end of any work unit that produces a complete, self-consistent change (workstream done, task done, feature done) → `git add {scope}` → `git commit` with a real message → `git push`. No waiting for a separate "please commit" prompt. The user expects it baked in.
  - **When commit+push needs user approval** (destructive git ops, force push, merging into main, pushing to a shared branch without a PR, commits touching secrets or CI config): do NOT silently hold the change. Say explicitly: "I have uncommitted changes at {paths}. Pushing would require {specific approval}. This is drift risk until resolved." Then wait. Keep flagging on every subsequent turn until it's pushed — drift risk is a standing hazard, not a one-time disclosure.
  - **WIP checkpoints:** for multi-hour work, push mid-stream on the feature branch. `claude/*` branches are cheap. Losing 3 hours of uncommitted work to a crashed worktree is worse than noise in the commit log.
  - **Never use destructive git ops** (`reset --hard`, `push --force`, `clean -fd`) to "fix" a mess when the root cause is actually "I forgot to push earlier." Push first, then think about the mess.
- **Check:** At every turn that ends a work unit, before the final summary message, run `git status` mentally:
  - Any "modified" or "Untracked" under the scope I just worked on? → commit + push in the same turn, OR flag drift risk explicitly.
  - Final message ends a session or hands back to user? → `git status` must be clean OR the drift-risk flag must appear in the message.
  - If uncertain whether to push now: default to pushing. A merge/rebase is recoverable; a lost worktree is not.
- **You are the CPO / lead architect, not a subordinate.** Mamoun delegates executing authority to you on this kind of work. Do not ask "want me to open the PR?" or "want me to merge?" — open it, merge it, fix the drift. The approval bar stays high only for: (a) force push / branch delete / `reset --hard` / `clean -fd`, (b) production deploys to smo-prod or eo-prod, (c) cross-repo edits that affect someone else's in-progress work, (d) anything touching customer data or secrets. Everything else on a `claude/*` branch or a feature branch owned by the work: just do it. "Zero drift" is the objective — if you've pushed a branch but not merged, not opened a PR, or not updated a version reference that install.sh reads, drift is still open and it's on you to close it.
- **Enforcement:** This lesson is loaded at every SessionStart. If you've made edits in this session and are about to respond to the user without having pushed, opened the PR, merged, and verified no stale version references remain — STOP. Resolve first. Do not end a turn on unpushed, unmerged, or drift-carrying work in silence, and do not end a turn asking permission for the obvious next step.
- **Last triggered:** 2026-04-21


### L-016 — Check ALL git branches before claiming work is lost
- **Captured:** 2026-04-23
- **Trigger:** Claimed April 10-18 SSE V3 work was "unrecoverable" (L-009 violation). User pushed back: "check the repo." Turned out 46 workflows (including all April work — Firecrawl, Clay, GHL sync, signal-scoring, adapted ACE variants) lived on `agent/SSE-P2-06-F` branch in Signal-Sales-Engine repo dated Apr 9, plus 49 dev commits ahead of main with PostHog/Sentry/i18n/dashboard mobile/BRD schema views. Wasted 2+ hours telling Mamoun work was gone; it was right there. Only audited `main` + `dev`, never enumerated `agent/*` / `feat/*` / other branches.
- **Rule:** Before EVER saying "lost" or "unrecoverable": `git fetch --all --prune; git branch -r | wc -l; for b in $(git branch -r | grep -v HEAD); do echo "$b: $(git log $b --oneline | wc -l) commits, $(git ls-tree -r $b --name-only | wc -l) files"; done`. Check every remote branch, remote tags, stash list, reflog, any `archives/` dir in recovery folders.
- **Check:** `/smo-triage` hypothesis phase must list every accessible-via-git branch on the relevant repo before concluding anything is missing.
- **Enforcement:** Don't write "lost" or "unrecoverable" without attaching a `git branch -r` output proving no branch has it.
- **Last triggered:** 2026-04-23

### L-017 — Enumerate ALL recovery archives before picking one
- **Captured:** 2026-04-23
- **Trigger:** MASTER-PLAN mentioned `/root/SSE.zip` so I used that. Later found `signal_project_v3.zip` IN THE SAME DIRECTORY with a later snapshot (Mar 31 vs Mar 27) containing production-adapted ACE workflows + nginx config + ctl.sh. Imported from the older one, missed the newer until user called it out.
- **Rule:** When any recovery folder is relevant: list EVERY archive with size + latest file date INSIDE. Pick the newest by CONTENT date, not filename. `find $DIR -type f \( -name "*.zip" -o -name "*.tar.gz" \) -exec sh -c 'echo "==$1=="; unzip -l "$1" 2>/dev/null | tail -3' _ {} \;`
- **Check:** Before using any archive for restore, output archive inventory showing date-inside, not date-created-on-disk. If two archives overlap, diff them before picking.
- **Last triggered:** 2026-04-23

### L-018 — "Not visible in UI" ≠ "not in database"
- **Captured:** 2026-04-23
- **Trigger:** User said "n8n is empty on smo.prod and smo.dev." I believed it. Reality: 270 + 235 workflows existed in both databases — user was logging in and n8n 1.80+ project isolation hid other users' personal projects. Data was FINE. My initial "empty" narrative was wrong.
- **Rule:** When a user reports UI empty / data missing, FIRST query the underlying store directly (SQL, Supabase REST, Mongo CLI, sqlite on disk). Only after confirming data is GONE at the store level, escalate to "recovery needed." UI-layer hiding (RBAC, project isolation, filter defaults, session, cache) is almost always the real cause.
- **Check:** `/smo-triage` first step for "data missing" reports: direct store-level query, paste row count + schema confirmation before considering data is lost.
- **Last triggered:** 2026-04-23

### L-019 — Never shell-heredoc multi-line Python. Use Write + scp
- **Captured:** 2026-04-23
- **Trigger:** Tried to fix /root/.claude/settings.json via `ssh ... python3 <<PY ... PY`. Shell escaping nested with Python raw-strings + JSON escapes = 3 failed attempts. SyntaxError on the docstring because `\u` in "User" triggered unicode escape; another attempt: JSON double-escaped valid sequences.
- **Rule:** Any Python script longer than 3 lines goes into a file via Write tool (raw content, no shell escape layer), then scp to the server, then `python3 /tmp/script.py`. Do NOT shell-heredoc multi-line Python with backslashes, quotes, or `\N` patterns.
- **Check:** If a Python script fails with SyntaxError or escape error inside ssh heredoc, pivot IMMEDIATELY to Write+scp, don't retry the heredoc.
- **Last triggered:** 2026-04-23

### L-020 — Mount is not auth. Verify credentials before building on them
- **Captured:** 2026-04-23
- **Trigger:** Mounted `/root/.claude/.credentials.json` from host into runtime container, expected Claude CLI subprocess to "just work." OAuth tokens were expired (401). Discovered after mount + env + restart + curl. Should have tested `claude --print "reply ready"` on HOST first before any container plumbing.
- **Rule:** Before building infrastructure that depends on a credential/token, run a 1-command validity test on the source. OAuth tokens expire silently; a credentials file existing ≠ the token inside being valid.
- **Check:** For every credential injected/mounted into a container: (a) test on source first, (b) note expiry, (c) document refresh path in deploy evidence.
- **Last triggered:** 2026-04-23

### L-021 — Log noise ≠ blocker. Grep for actual references before panicking
- **Captured:** 2026-04-23
- **Trigger:** n8n import log showed `ENOENT: n8n-nodes-think-mcp-server/package.json`. Claimed this was blocking workflow activation. Told user to install it; npm said 404. All wrong — `SELECT name FROM workflow_entity WHERE nodes LIKE '%think-mcp%'` returned ZERO rows. The warning was cosmetic — n8n scans a directory listing that references the node but no workflow uses it.
- **Rule:** When a log says "X is missing," BEFORE declaring "X is needed" — grep the actual usage (SQL against relevant column, grep in JSONs, search in codebase). ENOENT warnings are often stale manifest/cache references, not live dependencies.
- **Check:** Every ENOENT / missing-module / 404 log line must be matched with an active-usage grep proving SOMETHING uses it. Zero references = cosmetic.
- **Last triggered:** 2026-04-23

### L-022 — rsync --delete wipes server-generated state. Always exclude or regenerate
- **Captured:** 2026-04-23
- **Trigger:** Ran `rsync -az --delete` twice to push content-automation from local to smo-prod. First pass wiped `docker-compose.override.yml` I'd just created (port mappings + internal nginx disable). Second pass wiped `.env` with freshly-generated postgres password + RUNTIME_API_KEY. Each time I had to regenerate.
- **Rule:** `rsync --delete` treats source as sole truth. Anything generated/configured server-side gets nuked. Options: (a) `--exclude='docker-compose.override.yml' --exclude='.env*' --exclude='.claude/' --exclude='.local/'`, (b) store server-specific config outside the rsync'd tree (`/etc/{app}/` or `/opt/config/`), (c) don't use `--delete` unless intentional.
- **Check:** Before ANY `rsync -a --delete` into an app dir: check for `.env*`, `*.override.yml`, `.claude/`, `.local/` on target — exclude or back up first.
- **Last triggered:** 2026-04-23

### L-023 — DNS NXDOMAIN caches persist for SOA negative TTL. Plan for it
- **Captured:** 2026-04-23
- **Trigger:** Added DNS A-record for `contentengine.smorchestra.ai` at domain.com. Authoritative NS returned the record within a minute. But user's browser + Tailscale MagicDNS + Google 8.8.8.8 cached the earlier NXDOMAIN for the SOA negative TTL (3600s = 1 hour). User saw `DNS_PROBE_FINISHED_NXDOMAIN`, thought the record didn't save.
- **Rule:** When adding a brand-new DNS record, immediately tell user: (a) authoritative has the record (verify `dig @ns1 +short`), (b) public resolvers may cache NXDOMAIN up to 1 hour — give them the `/etc/hosts` override (`IP hostname`) as immediate workaround, (c) flushing Mac DNS alone is insufficient because Tailscale MagicDNS overrides.
- **Check:** Any new-subdomain evidence file must list the three NXDOMAIN-cache workarounds: /etc/hosts, switch DNS to 1.1.1.1/9.9.9.9, disable Tailscale --accept-dns.
- **Last triggered:** 2026-04-23

### L-024 — "Imported N" ≠ N new rows. Verify delta
- **Captured:** 2026-04-23
- **Trigger:** `n8n import:workflow` reported "Successfully imported 29 workflows." Reported "29 imported." Reality: counts went 270 → 289, delta = **19 new, 10 overwrote existing rows** with matching IDs. Existing production-active versions got silently replaced with older git-canonical copies.
- **Rule:** For any bulk-import operation: measure `count BEFORE`, run import, measure `count AFTER`. Report `delta = AFTER - BEFORE` as the honest number. "Imported N" is the count processed, not newly created. When overwriting is possible, explicitly report: `N imported = M new + (N-M) overwrote existing`.
- **Check:** Every import script/log must compute + print `count_before, count_after, delta`. Reported success with delta < total-claimed = silent overwrite warning.
- **Last triggered:** 2026-04-23

### L-025 — For multi-branch repos, `main` ≠ canonical. Audit ahead-of-main branches
- **Captured:** 2026-04-23
- **Trigger:** Signal-Sales-Engine `main` had 41 workflow JSONs. `dev` had 39. `agent/SSE-P2-06-F` had 56 with 15 net-new April workflows. smorch-brain `main` was missing SOPs that existed on `dev`. In both cases, `main` was STALE relative to active dev work. Assuming `main` = canonical led me to miss real current-state.
- **Rule:** Per repo: `for b in $(git branch -r); do ahead=$(git rev-list --count main..$b 2>/dev/null); [ $ahead -gt 0 ] && echo "$b: $ahead ahead"; done`. Any branch >0 ahead is a candidate for current-state. Check file counts, commit dates per branch. Canonical `main` is only canonical if branch protection + regular merges enforce it — many repos don't yet.
- **Check:** Every repo audit produces a "branches ahead of main" report. `/smo-drift --repos` flags any main with >5 dev commits behind as "stale main" SEV3.
- **Last triggered:** 2026-04-23

---

### L-015 — Subdomain-per-app, never basepath routing
- **Captured:** 2026-04-23
- **Trigger:** Deployed content-automation at `app.smorchestra.ai/contentengine` using Next.js `basePath: '/contentengine'`. Routing broke: Next.js served mixed asset paths (`/_next/*` AND `/contentengine/_next/*`), `/contentengine/generate` returned 404 despite the page existing in the build, Next.js internal resolution hit `/_not-found` instead of the page route. Spent extra cycles debugging instead of using what we already had with sse./score./gtm./flows. (which all just work).
- **Rule:** Every deployed app gets its OWN subdomain. No basepath multi-app routing on a shared domain. Canonical pattern: `{app}.smorchestra.ai` (SMO) / `{app}.entrepreneursoasis.me` (EO). Staging: `staging-{app}.{domain}` on smo-dev. Next.js config: NO `basePath`, NO `assetPrefix` (serve at root of subdomain).
- **Check:** `/smo-deploy` rejects `.smorch/project.json:deploy.production.health_url` that matches `https://{hub}.smorchestra.ai/{path}/*` pattern (basepath under a shared hub). `/smo-drift --nginx` flags any nginx vhost with >1 app served via separate `location /app-name/` blocks on the same server_name.
- **Enforcement:** SOP-35 (Dev → Prod Promotion) lists this as a blocked anti-pattern. Pre-commit hook in content-* app next.config.mjs rejects commits that reintroduce `basePath:` unless the app is genuinely a sub-route of a larger single-page shell.
- **Last triggered:** 2026-04-23

---

## How lessons compound

This file is loaded at every Claude Code session start for Mamoun's machine. Claude reads these before any work. Every time a pattern surfaces that could be a cross-project rule → add a lesson HERE (global). Project-specific lessons go in `{project}/.claude/lessons.md`.

**Promotion rule:** a lesson in a project's `.claude/lessons.md` that triggers in ≥3 different projects gets promoted here by `/smo-retro`.

**Pruning:** quarterly, any lesson not triggered in 180 days gets archived below (not deleted — audit trail).

---

## Archived lessons

None yet.
