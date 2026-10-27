#!/bin/bash

set -euo pipefail

echo "Checking dependencies..."

# 1. Docker
if command -v docker > /dev/null 2>&1; then
  echo "Docker already installed, skipping."
else
  echo "Installing Docker..."

  sudo apt-get update
  sudo apt-get install -y ca-certificates curl

  sudo install -m 0755 -d /etc/apt/keyrings

  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
      -o /etc/apt/keyrings/docker.asc

  sudo chmod a+r /etc/apt/keyrings/docker.asc

  sudo tee /etc/apt/sources.list.d/docker.sources > /dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

  sudo apt-get update
  sudo apt-get install -y \
      docker-ce docker-ce-cli containerd.io \
      docker-buildx-plugin docker-compose-plugin

  sudo usermod -aG docker "$USER"
fi

# 2. kubectl
if command -v kubectl > /dev/null 2>&1; then
  echo "kubectl already installed, skipping."
else
  echo "Installing kubectl..."

  KUBECTL_VERSION=$(curl -fsSL https://dl.k8s.io/release/stable.txt)

  curl -fL -o /tmp/kubectl \
      "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"

  sudo install -m 0755 /tmp/kubectl /usr/local/bin/kubectl
  rm /tmp/kubectl
fi

# 3. K3d
if command -v k3d > /dev/null 2>&1; then
  echo "K3d already installed, skipping."
else
  echo "Installing K3d..."

  curl -fsSL https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
fi

echo "Installation checks complete!"
echo "If Docker was not installed, log out and log back in before using Docker without sudo."