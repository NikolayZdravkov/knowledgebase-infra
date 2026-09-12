#!/bin/bash
set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

if [ -f .env ]; then
  source .env
fi

if [ ! -d .venv ]; then
  python3 -m venv .venv
fi

source .venv/bin/activate
pip install -q -r requirements.txt

INVENTORY="ansible/inventory/hosts.hcloud.yaml"

if [ -z "$HCLOUD_TOKEN" ]; then
  echo "Error: HCLOUD_TOKEN is not set"
  exit 1
fi

echo ">>> Creating localadmin user..."
ansible-playbook -i "$INVENTORY" ansible/playbooks/create-localadmin-user.yml -e ansible_user=root

echo ">>> Hardening server..."
ansible-playbook -i "$INVENTORY" ansible/playbooks/harden.yml -e ansible_user=root

echo ">>> Deploying k3s..."
ansible-playbook -i "$INVENTORY" ansible/playbooks/deploy_k3s.yaml

echo ">>> Deploying ArgoCD..."
ansible-playbook -i "$INVENTORY" ansible/playbooks/deploy_argocd.yaml

echo ">>> Done."


