#!/usr/bin/env bash
set -e

echo "  Updating system and dependencies...   "

export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y curl

echo "       K3s installation (Server)...     "

curl -sfL https://get.k3s.io | \
  K3S_KUBECONFIG_MODE="644" \
  INSTALL_K3S_EXEC="server --node-ip=192.168.56.110" \
  sh -

echo "   Waiting for the node to be ready...  "

until kubectl get nodes | grep -q " Ready"; do
  echo "Waiting for K3s..."
  sleep 2
done

echo " Applying configurations... "

kubectl apply -f /vagrant/confs/

echo "       Succesful deployment  !    "