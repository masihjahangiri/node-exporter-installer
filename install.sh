#!/bin/bash

set -e

echo "[INFO] Updating system and installing dependencies..."
sudo apt update -y && sudo apt install -y curl jq

echo "[INFO] Creating node_exporter user..."
sudo useradd --no-create-home --shell /bin/false node_exporter || true

echo "[INFO] Fetching latest Node Exporter release..."
LATEST_VERSION=$(curl -s https://api.github.com/repos/prometheus/node_exporter/releases/latest | jq -r .tag_name | sed 's/v//')

ARCH=$(uname -m)
if [[ $ARCH == "x86_64" ]]; then
    ARCH="amd64"
elif [[ $ARCH == "aarch64" ]]; then
    ARCH="arm64"
elif [[ $ARCH == "armv7l" ]]; then
    ARCH="armv7"
else
    echo "[ERROR] Unsupported architecture: $ARCH"
    exit 1
fi

echo "[INFO] Downloading Node Exporter v${LATEST_VERSION} for ${ARCH}..."
wget https://github.com/prometheus/node_exporter/releases/download/v${LATEST_VERSION}/node_exporter-${LATEST_VERSION}.linux-${ARCH}.tar.gz

tar -xvf node_exporter-${LATEST_VERSION}.linux-${ARCH}.tar.gz
sudo mv node_exporter-${LATEST_VERSION}.linux-${ARCH}/node_exporter /usr/local/bin/
rm -rf node_exporter-${LATEST_VERSION}.linux-${ARCH}*

echo "[INFO] Creating systemd service..."
sudo tee /etc/systemd/system/node_exporter.service > /dev/null <<EOF
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

echo "[INFO] Starting Node Exporter..."
sudo systemctl daemon-reload
sudo systemctl enable --now node_exporter

echo "[INFO] Opening port 9100..."
sudo ufw allow 9100/tcp || true

echo "[SUCCESS] Node Exporter is now running!"
echo "Access it at: http://$(hostname -I | awk '{print $1}'):9100/metrics"
