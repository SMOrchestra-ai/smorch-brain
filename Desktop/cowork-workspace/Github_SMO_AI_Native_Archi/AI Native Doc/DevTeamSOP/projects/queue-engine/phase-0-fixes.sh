#!/usr/bin/env bash
# Phase 0: Fix all prerequisites blockers
# Run: bash phase-0-fixes.sh [smo-brain|smo-dev|desktop]
# Each section is idempotent — safe to re-run.

set -euo pipefail

NODE="${1:-detect}"

# Auto-detect node
if [[ "$NODE" == "detect" ]]; then
  HOSTNAME=$(hostname)
  if [[ "$HOSTNAME" == *"vmi3051702"* ]] || tailscale status 2>/dev/null | grep -q "smo-brain.*linux.*-$"; then
    # Check if this IS smo-brain by looking at local IP
    if ip addr show 2>/dev/null | grep -q "100.89.148.62"; then
      NODE="smo-brain"
    elif ip addr show 2>/dev/null | grep -q "100.117.35.19"; then
      NODE="smo-dev"
    else
      NODE="desktop"
    fi
  else
    NODE="desktop"
  fi
  echo "Auto-detected node: $NODE"
fi

echo "========================================="
echo "Phase 0 Fixes — Node: $NODE"
echo "========================================="

# ─── B3: Configure git to use HTTPS (not SSH) ───
echo ""
echo "[B3] Configuring git to use HTTPS instead of SSH..."
git config --global url."https://github.com/".insteadOf "git@github.com:"
git config --global url."https://github.com/".insteadOf "ssh://git@github.com/"
echo "  ✓ Git now uses HTTPS for all GitHub operations"

# ─── B4: Set git identity for agent work ───
echo ""
echo "[B4] Setting git identity..."
git config --global user.name "SMOrchestra AI Agent"
git config --global user.email "agents@smorchestra.ai"
echo "  ✓ Git identity: SMOrchestra AI Agent <agents@smorchestra.ai>"

# ─── Node-specific fixes ───
case "$NODE" in
  smo-brain)
    # B1: OpenClaw — report status, don't auto-fix (needs investigation)
    echo ""
    echo "[B1] OpenClaw status check..."
    if systemctl is-active --quiet openclaw 2>/dev/null; then
      echo "  ✓ OpenClaw is running"
    else
      echo "  ✗ OpenClaw is DEAD"
      echo "  → Error: missing dist/entry.(m)js (build output)"
      echo "  → Manual fix needed: rebuild OpenClaw from source"
      echo "  → Check: ls /usr/local/lib/node_modules/openclaw/dist/"
      echo "  → Try: cd /usr/local/lib/node_modules/openclaw && npm run build"
      echo "  → Then: systemctl start openclaw"
    fi

    # Verify n8n
    echo ""
    echo "[CHECK] n8n health..."
    if curl -sf localhost:5678/healthz > /dev/null 2>&1; then
      echo "  ✓ n8n is healthy"
    else
      echo "  ✗ n8n is not responding"
      echo "  → Try: docker start n8n"
    fi

    # Verify Codex
    echo ""
    echo "[CHECK] Codex CLI..."
    if which codex > /dev/null 2>&1; then
      echo "  ✓ Codex $(codex --version 2>&1)"
    else
      echo "  → Installing Codex..."
      npm i -g @openai/codex
      echo "  ✓ Codex installed"
    fi
    ;;

  smo-dev)
    # N1: Install Codex
    echo ""
    echo "[N1] Codex CLI..."
    if which codex > /dev/null 2>&1; then
      echo "  ✓ Codex already installed"
    else
      echo "  → Installing Codex..."
      npm i -g @openai/codex
      echo "  ✓ Codex installed"
    fi

    # N4: Install sqlite3
    echo ""
    echo "[N4] sqlite3..."
    if which sqlite3 > /dev/null 2>&1; then
      echo "  ✓ sqlite3 already installed"
    else
      echo "  → Installing sqlite3..."
      apt-get update -qq && apt-get install -y -qq sqlite3
      echo "  ✓ sqlite3 installed"
    fi

    # B2: n8n — check and report
    echo ""
    echo "[B2] n8n status..."
    if curl -sf localhost:5678/healthz > /dev/null 2>&1; then
      echo "  ✓ n8n is healthy"
    elif docker ps 2>/dev/null | grep -q n8n; then
      echo "  ✓ n8n container exists but may not be healthy"
    else
      echo "  ✗ n8n is NOT running"
      echo "  → Need to start n8n Docker container"
      echo "  → Check: docker images | grep n8n"
      echo "  → If image exists: docker run -d --name n8n -p 5678:5678 -v n8n_data:/home/node/.n8n n8nio/n8n"
      echo "  → If no image: docker pull n8nio/n8n && (above command)"
    fi

    # Verify gh CLI active account
    echo ""
    echo "[CHECK] gh CLI account..."
    ACTIVE_ACCOUNT=$(gh auth status 2>&1 | grep "Active account: true" -B3 | head -1 | awk '{print $NF}')
    echo "  Active gh account: $ACTIVE_ACCOUNT"
    if [[ "$ACTIVE_ACCOUNT" != *"smorchestraai-code"* ]]; then
      echo "  ⚠ Consider switching: gh auth switch --user smorchestraai-code"
    fi
    ;;

  desktop)
    # N3: Install gh CLI
    echo ""
    echo "[N3] gh CLI..."
    if which gh > /dev/null 2>&1; then
      echo "  ✓ gh already installed"
    else
      echo "  → Installing gh via Homebrew..."
      if which brew > /dev/null 2>&1; then
        brew install gh
        echo "  → Run: gh auth login"
      else
        echo "  ✗ Homebrew not found. Install gh manually."
      fi
    fi

    # N2: Check Codex
    echo ""
    echo "[N2] Codex CLI..."
    if which codex > /dev/null 2>&1; then
      echo "  ✓ Codex found at $(which codex)"
    else
      # Check common locations
      for p in /usr/local/bin/codex /opt/homebrew/bin/codex "$HOME/.npm-global/bin/codex"; do
        if [[ -f "$p" ]]; then
          echo "  → Found at $p (not in PATH)"
          echo "  → Add to PATH or: ln -s $p /usr/local/bin/codex"
          break
        fi
      done
      echo "  → If not found: npm i -g @openai/codex"
    fi
    ;;
esac

# ─── Skills sync check ───
echo ""
echo "[N5] Skills count..."
SKILL_COUNT=$(ls ~/.claude/skills/ 2>/dev/null | wc -l | tr -d ' ')
echo "  Skills on $NODE: $SKILL_COUNT"

# ─── Final verification ───
echo ""
echo "========================================="
echo "Verification"
echo "========================================="
echo "Git HTTPS:  $(git config --global url.https://github.com/.insteadOf 2>/dev/null || echo 'not set')"
echo "Git name:   $(git config --global user.name 2>/dev/null || echo 'not set')"
echo "Git email:  $(git config --global user.email 2>/dev/null || echo 'not set')"
echo "Claude:     $(claude --version 2>/dev/null || echo 'not found')"
echo "Codex:      $(which codex 2>/dev/null && codex --version 2>/dev/null || echo 'not found')"
echo "gh:         $(which gh 2>/dev/null && gh auth status 2>&1 | grep -m1 'Logged in' || echo 'not found')"
echo "sqlite3:    $(which sqlite3 2>/dev/null || echo 'not found')"
echo "jq:         $(which jq 2>/dev/null || echo 'not found')"
echo "Skills:     $SKILL_COUNT"
echo "========================================="
echo "Phase 0 fixes complete for $NODE"
