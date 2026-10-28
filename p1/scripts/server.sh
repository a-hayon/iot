#!/usr/bin/env bash
set -e

apt-get update
apt-get install -y curl

# 644 to authorize non-root user to read kubeconfig / use kubectl commands
curl -sfL https://get.k3s.io | \
  K3S_KUBECONFIG_MODE="644" \
  K3S_TOKEN="$K3S_TOKEN" \
  INSTALL_K3S_EXEC="server --node-ip=192.168.56.110" \
  sh -