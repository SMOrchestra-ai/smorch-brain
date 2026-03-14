#!/bin/bash
# SMOrchestra Brain - GitHub Push + Claude Code Setup
# Pushes to: https://github.com/SMOrchestra-ai/smorch-brain
# Run this from your Mac terminal inside the extracted repo folder

set -e

ORG="SMOrchestra-ai"
REPO_NAME="smorch-brain"
REPO_URL="git@github.com:${ORG}/${REPO_NAME}.git"
HTTPS_URL="https://github.com/${ORG}/${REPO_NAME}"

echo "=== SMOrchestra Brain Setup ==="
echo "Target: ${HTTPS_URL}"
echo ""

# Step 1: Push to GitHub org
echo "[1/4] Pushing to ${ORG}/${REPO_NAME}..."
if ! command -v gh &> /dev/null; then
    echo "  gh CLI not found. Install it: brew install gh"
    echo "  Then run: gh auth login"
    exit 1
fi

# Check if repo already exists in the org
if gh repo view "${ORG}/${REPO_NAME}" &>/dev/null; then
    echo "  Repo already exists. Adding remote and pushing..."
    git remote remove origin 2>/dev/null || true
    git remote add origin "${REPO_URL}"
    git branch -M main
    git push -u origin main
else
    echo "  Creating private repo under ${ORG}..."
    gh repo create "${ORG}/${REPO_NAME}" --private --source=. --remote=origin --push
fi

echo "  Done: ${HTTPS_URL}"
echo ""

# Step 2: Install skills into Claude Code
echo "[2/4] Installing skills into Claude Code..."
CLAUDE_SKILLS_DIR="$HOME/.claude/skills"
mkdir -p "$CLAUDE_SKILLS_DIR"

cp -r skills/* "$CLAUDE_SKILLS_DIR/"
echo "  Copied $(ls skills/ | wc -l | tr -d ' ') skills to $CLAUDE_SKILLS_DIR"
echo ""

# Step 3: Install CLAUDE.md
echo "[3/4] Installing CLAUDE.md..."
CLAUDE_DIR="$HOME/.claude"
mkdir -p "$CLAUDE_DIR"

if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
    echo "  CLAUDE.md already exists. Backing up to CLAUDE.md.backup"
    cp "$CLAUDE_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md.backup"
fi
cp CLAUDE.md "$CLAUDE_DIR/CLAUDE.md"
echo "  Done."
echo ""

# Step 4: Plugin install instructions
echo "[4/4] Plugin setup..."
echo "  To install plugins in Claude Code, run:"
echo "    claude plugin add ./plugins/smorch-gtm-engine"
echo "    claude plugin add ./plugins/eo-microsaas-os"
echo ""
echo "=== Setup Complete ==="
echo ""
echo "Your 62 skills are now available in Claude Code as slash commands."
echo "Test it: open Claude Code and type /signal-to-trust-gtm"
