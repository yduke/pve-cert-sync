#!/bin/bash

REPO_URL="https://raw.githubusercontent.com/yduke/pve-cert-sync/main"

echo "==> Installing PVE Cert Sync..."

# 下载主脚本
curl -fsSL $REPO_URL/pve-cert-sync.sh -o /usr/local/bin/pve-cert-sync
chmod +x /usr/local/bin/pve-cert-sync

# 安装 systemd 服务
mkdir -p /etc/systemd/system
curl -fsSL $REPO_URL/systemd/pve-cert-sync.service -o /etc/systemd/system/pve-cert-sync.service
curl -fsSL $REPO_URL/systemd/pve-cert-sync.timer -o /etc/systemd/system/pve-cert-sync.timer

# 启用定时任务
systemctl daemon-reload
systemctl enable --now pve-cert-sync.timer

echo "==> Install complete!"
echo "Script installed at:   /usr/local/bin/pve-cert-sync"
echo "Timer active:          systemctl status pve-cert-sync.timer"
