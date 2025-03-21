# 🚀 Node Exporter Installer for Ubuntu

This repo provides a **one-liner installation** script to quickly install [Prometheus Node Exporter](https://github.com/prometheus/node_exporter) on an Ubuntu server.

✅ Automatically:
- Detects latest Node Exporter version
- Detects CPU architecture (x86_64, arm64, etc.)
- Downloads & installs Node Exporter
- Sets up systemd service
- Opens port `9100` (if using UFW)

---

## 🧪 Tested On
- Ubuntu 20.04 / 22.04 / 24.04
- Architectures: `amd64`, `arm64`, `armv7`

---

## ⚡ Quick Install

Run this command on your Ubuntu server:

```bash
bash <(curl -Ls https://raw.githubusercontent.com/masihjahangiri/node-exporter-installer/main/install.sh)
```