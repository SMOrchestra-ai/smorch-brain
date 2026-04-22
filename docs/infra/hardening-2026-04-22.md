# Phase A — Hardening Evidence (4 Servers)

**Date:** 2026-04-22 UTC
**Script:** `smorch-dev/scripts/hardening/apply-hardening.sh` (idempotent)
**Applied by:** Claude (acting as Lead Architect under CEO Mamoun Alamouri)

## Summary

All 4 SMOrchestra Contabo VPS servers now baseline-hardened per plan Phase A. Non-destructive (config additions only, nothing deleted). SSH still works via key on all 4.

## Matrix

| Check | smo-prod | smo-dev | eo-prod | smo-eo-qa |
|---|---|---|---|---|
| UFW status | active ✅ | active ✅ | active ✅ | active ✅ |
| fail2ban | active ✅ | active ✅ | active ✅ | active ✅ |
| Banned IPs (at verify) | 18 | 13 | 0 | 1 |
| SSH PasswordAuthentication | no ✅ | no ✅ | no ✅ | no ✅ |
| SSH PermitRootLogin | prohibit-password ✅ | prohibit-password ✅ | prohibit-password ✅ | prohibit-password ✅ |
| Swap | 4.0 GiB ✅ | 4.0 GiB ✅ | 2.0 GiB ✅ | 4.0 GiB ✅ |
| `/etc/ld.so.preload` | absent ✅ | absent ✅ | absent ✅ | absent ✅ |
| perfctl-sentinel cron | installed ✅ | installed ✅ | installed ✅ | installed ✅ |
| unattended-upgrades | active ✅ | active ✅ | active ✅ | active ✅ |
| logrotate /opt/logs | configured ✅ | configured ✅ | configured ✅ | configured ✅ |

## Rules applied (UFW)

```
Default deny incoming, allow outgoing
  22/tcp   (SSH)
  80/tcp   (HTTP — nginx redirects to 443)
  443/tcp  (HTTPS)
  tailscale0 (allow in on interface — Tailscale mesh)
```

## fail2ban

```
/etc/fail2ban/jail.local:
[sshd]
enabled  = true
port     = 22
maxretry = 5
findtime = 600
bantime  = 3600
```

## SSH hardening

`/etc/ssh/sshd_config`:
- `PasswordAuthentication no`
- `PermitRootLogin prohibit-password`
- Key-only auth (deploy key + mamoun's mbp key)

## unattended-upgrades

`/etc/apt/apt.conf.d/52unattended-reboot`:
- Auto-patch enabled
- Auto-reboot Mon 02:00 UTC for kernel updates

## Perfctl sentinel

`/opt/scripts/perfctl-sentinel.sh` runs every 30 min:
- Checks `/etc/ld.so.preload`, `/lib/libgcwrap.so`, `/etc/cron.d/perfclean`, `/root/.config/cron`
- Alerts to `https://flow.smorchestra.ai/webhook/perfctl-alert` if any indicator found
- Logs to `/var/log/perfctl-sentinel.log`

## Swap

- smo-prod, smo-dev, smo-eo-qa: 4 GB swapfile at `/swapfile` (new)
- eo-prod: 2 GB swap already existed, kept as-is (479 MiB in use at time of check)

## Notes

- **fail2ban already blocked 32 bot IPs across 4 servers** by time of verification — confirms active scanning against SSH. Hardening effective.
- No service downtime during hardening (all config additions, no service restarts beyond SSH reload + fail2ban start).
- All 4 servers continue to serve production URLs (flow.smorchestra.ai, score.smorchestra.ai, ai.mamounalamouri.smorchestra.com, entrepreneursoasis.me).

## Gate to next phase

Phase A ✅ COMPLETE. Ready for Phase B (Server Role Mapping + comprehensive repo inventory).

