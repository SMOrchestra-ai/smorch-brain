# GitHub Decision: Lana Al-Kurd Organization Access

**Date:** March 31, 2026
**Decision By:** Mamoun Alamouri
**Status:** DECIDED — Option B (GitHub Team Plan, $4/user/month)

---

## The Question

Does @lanaalkurdsmo need a seat on the SMOrchestra-ai GitHub organization to collaborate effectively?

---

## Recommendation: YES — Add Lana as Org Member

**Short answer:** Lana MUST be an org member to do her job. Without it, she cannot review PRs, push branches, or access private repos.

---

## Why She Needs Access

| Task (from SOP-4 & SOP-5) | Requires Org Access? | Why |
|---------------------------|---------------------|-----|
| Review agent PRs on dev | YES | PRs are on org repos — she needs read access minimum |
| Comment on PRs with review findings | YES | Write access to leave comments |
| Push `human/lana/TASK-XXX` branches | YES | Write access to push branches |
| Create issues and bug reports | YES | Write access to create issues |
| Access private repos (most are private) | YES | Private repos invisible without org membership |
| Run code locally (clone private repos) | YES | Can't clone private repos without access |
| Test staging environments | PARTIAL | Depends on deployment setup |

**Without org access, Lana can do NONE of her defined responsibilities.** The entire SOP-4 (Team Distribution) and SOP-5 (Dev Roles) become inoperative.

---

## GitHub Plan Options

### Option A: Free Plan — Add as Member (Cost: $0)

| Feature | Available? |
|---------|-----------|
| Unlimited public repos | YES |
| Unlimited collaborators | YES |
| Private repo access (read/write) | YES |
| Branch protection rules (basic) | YES |
| Required pull request reviews | NO — needs Team plan |
| CODEOWNERS enforcement | NO — needs Team plan |
| Protected branches with required status checks | LIMITED |

**Limitation:** On Free plan, branch protection with required reviewers and CODEOWNERS is not enforced by GitHub. Our SOPs specify these, but enforcement would be process-based (trust), not tool-enforced.

### Option B: GitHub Team Plan — Add as Member (Cost: $4/user/month)

| Feature | Available? |
|---------|-----------|
| Everything in Free | YES |
| Required pull request reviews | YES — enforced by GitHub |
| CODEOWNERS enforcement | YES — enforced by GitHub |
| Protected branches with all options | YES |
| Code owners required reviews | YES |
| Draft pull requests | YES |
| Multiple reviewers | YES |

**This matches our SOPs exactly.** SOP-3 requires branch protection on main + dev with required reviews. Team plan enforces this at the platform level.

### Option C: Outside Collaborator (Cost: $0 on Free, counts toward limit)

| Feature | Available? |
|---------|-----------|
| Access to specific repos only | YES |
| Can review PRs | YES |
| Can push branches | YES |
| Org-wide visibility | NO — sees only invited repos |
| Team membership features | NO |

**Workable but fragile.** Every new repo requires a separate invitation. She can't see the org dashboard. Not recommended for ongoing team member.

---

## My Recommendation

**Go with Option B: GitHub Team Plan at $4/user/month.**

Reasons:
1. Branch protection with required reviews is in our SOPs — Team plan enforces it at the platform level
2. CODEOWNERS enforcement ensures infra/auth/billing changes always route to Mamoun
3. The $4/month cost is negligible compared to the risk of unenforced branch protection
4. This also unblocks the Signal-Sales-Engine transfer (the "insufficient collaborator seats" error)

**If budget is tight:** Option A (Free + add as member) works — our git hooks and Claude Code's session bootstrap already enforce most of our rules. Branch protection would be process-enforced rather than platform-enforced. This is acceptable for a small team where trust is high.

---

## Action Steps (After Mamoun Approves)

### If Option A (Free):
```bash
# 1. Invite Lana to org
gh api orgs/SMOrchestra-ai/invitations -f email="lana-email@example.com" -f role="member"

# 2. After she accepts, add to engineering team
gh api orgs/SMOrchestra-ai/teams/engineering/memberships/lanaalkurdsmo -X PUT

# 3. Verify access
gh api orgs/SMOrchestra-ai/members --jq '.[].login'
```

### If Option B (Team Plan):
```bash
# 1. Upgrade org to Team plan
# Go to: https://github.com/organizations/SMOrchestra-ai/settings/billing/plans
# Select "Team" plan ($4/user/month)

# 2. Invite Lana to org
gh api orgs/SMOrchestra-ai/invitations -f email="lana-email@example.com" -f role="member"

# 3. After she accepts, add to engineering team
gh api orgs/SMOrchestra-ai/teams/engineering/memberships/lanaalkurdsmo -X PUT

# 4. Set up branch protection with required reviews (now enforceable)
# For each repo:
gh api -X PUT repos/SMOrchestra-ai/REPO/branches/main/protection \
  -f required_pull_request_reviews[required_approving_review_count]=1 \
  -f enforce_admins=true

gh api -X PUT repos/SMOrchestra-ai/REPO/branches/dev/protection \
  -f required_pull_request_reviews[required_approving_review_count]=1

# 5. Retry Signal-Sales-Engine transfer
gh api repos/smorchestraai-code/Signal-Sales-Engine/transfer \
  -f new_owner="SMOrchestra-ai"
```

---

## Connected Decision: Signal-Sales-Engine Transfer

The repo transfer from `smorchestraai-code` to `SMOrchestra-ai` was blocked by "insufficient collaborator seats." Upgrading to Team plan (Option B) should resolve this. If staying on Free plan (Option A), manual migration is needed:

```bash
# Manual migration (if Free plan)
gh repo create SMOrchestra-ai/Signal-Sales-Engine --private --default-branch dev
cd ~/local-clone-of-signal-sales-engine
git remote add org https://github.com/SMOrchestra-ai/Signal-Sales-Engine.git
git push org --all && git push org --tags
git remote remove origin && git remote rename org origin
gh repo archive smorchestraai-code/Signal-Sales-Engine --yes
```

---

## Decision Matrix

| Factor | Option A (Free) | Option B (Team $4/mo) | Option C (Outside Collab) |
|--------|----------------|----------------------|--------------------------|
| Lana can do her job | YES | YES | PARTIAL |
| Branch protection enforced | Process-only | Platform-enforced | Process-only |
| CODEOWNERS enforced | No | Yes | No |
| Signal-Sales-Engine transfer | Manual migration | Auto-unblocked | Manual migration |
| Monthly cost | $0 | $4/user × 2 users = $8/mo | $0 |
| Future team scaling | Add members, enforce later | Ready now | Fragile per-repo invites |
| **Recommendation** | Acceptable | **Best** | Not recommended |

---

**DECIDED: Option B — GitHub Team Plan ($4/user/month). Approved by Mamoun on March 31, 2026.**

## Execution Checklist

```
[ ] Mamoun: Upgrade org to Team plan at https://github.com/organizations/SMOrchestra-ai/settings/billing/plans
[ ] Mamoun: Invite @lanaalkurdsmo to SMOrchestra-ai org
[ ] Lana: Accept invitation
[ ] AI: Add Lana to engineering team
[ ] AI: Set up branch protection with required reviews on all 8 repos
[ ] AI: Retry Signal-Sales-Engine transfer from smorchestraai-code
[ ] AI: Verify all access and protections are working
[ ] Lana: Complete onboarding checklist (see lana-onboarding-guide)
```
