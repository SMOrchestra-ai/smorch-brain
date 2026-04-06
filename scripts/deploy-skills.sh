#!/bin/bash
# deploy-skills.sh — Sync smorch-brain plugins + final-sop to all servers
# Run from any machine with SSH access to smo-brain and smo-dev
# Usage: ./scripts/deploy-skills.sh

set -e

BRAIN_IP="100.89.148.62"
DEV_IP="100.117.35.19"
REPO_PATH="/root/smorch-brain"
PLUGIN_DIR="/root/.claude/plugins"

echo "=== SMOrchestra Skill Deployment ==="
echo "Deploying from smorch-brain to all servers..."
echo ""

for SERVER in "$BRAIN_IP" "$DEV_IP"; do
  NAME=$(ssh -o ConnectTimeout=5 root@$SERVER 'hostname' 2>/dev/null || echo "UNREACHABLE")

  if [ "$NAME" = "UNREACHABLE" ]; then
    echo "SKIP: $SERVER — cannot connect"
    continue
  fi

  echo "--- Deploying to $NAME ($SERVER) ---"

  ssh root@$SERVER "
    cd $REPO_PATH && \
    git stash 2>/dev/null; \
    git pull origin dev --rebase 2>&1 | tail -3 && \
    mkdir -p $PLUGIN_DIR && \
    ln -sf $REPO_PATH/plugins/engineering $PLUGIN_DIR/engineering && \
    ln -sf $REPO_PATH/plugins/product-management $PLUGIN_DIR/product-management && \
    ln -sf $REPO_PATH/plugins/smorch-dev $PLUGIN_DIR/smorch-dev && \
    ln -sf $REPO_PATH/plugins/smorch-gtm-engine $PLUGIN_DIR/smorch-gtm-engine && \
    ln -sf $REPO_PATH/plugins/smorch-gtm-tools $PLUGIN_DIR/smorch-gtm-tools && \
    echo 'Plugins:' && ls $PLUGIN_DIR/ && \
    echo 'Final SOP:' && ls $REPO_PATH/final-sop/ && \
    echo 'DONE'
  "
  echo ""
done

echo "=== Deployment Complete ==="
echo "Source of truth: smorch-brain/plugins/ + smorch-brain/final-sop/"
echo "Servers synced: smo-brain ($BRAIN_IP), smo-dev ($DEV_IP)"
