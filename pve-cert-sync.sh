#!/bin/bash

ACME_SERVER="192.168.2.1:16666"
CERT_DIR="/etc/pve/local"
TMP_DIR="/tmp/pve-sync"
LOG="/var/log/pve-cert-sync.log"
DOMAIN="yins.top"

mkdir -p "$TMP_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG"
}

log "=== PVE Certificate Sync Start ==="

# 下载证书
curl -fsSL http://$ACME_SERVER/$DOMAIN.pem -o $TMP_DIR/fullchain.pem
curl -fsSL http://$ACME_SERVER/$DOMAIN.key -o $TMP_DIR/privkey.key

if [[ ! -s $TMP_DIR/fullchain.pem || ! -s $TMP_DIR/privkey.key ]]; then
    log "ERROR: 下载证书失败，跳过更新。"
    exit 1
fi

# 检查剩余有效期
DAYS_LEFT=$(openssl x509 -enddate -noout -in $TMP_DIR/fullchain.pem | cut -d= -f2 | xargs -I{} date -d "{}" +%s)
NOW=$(date +%s)
VALID_DAYS=$(( (DAYS_LEFT - NOW) / 86400 ))

log "证书剩余有效期：$VALID_DAYS 天"

if (( VALID_DAYS > 20 )); then
    log "证书有效期大于 20 天（$VALID_DAYS 天），无需更新。"
    exit 0
fi

log "证书有效期小于 20 天，更新证书..."

cp $TMP_DIR/fullchain.pem $CERT_DIR/pveproxy-ssl.pem
cp $TMP_DIR/privkey.key $CERT_DIR/pveproxy-ssl.key

chmod 600 $CERT_DIR/pveproxy-ssl.key

# 重载 PVE 服务
systemctl reload pveproxy
systemctl reload pvedaemon
systemctl restart pvestatd

log "证书更新完成，并已重启 PVE 服务。"
log "=== PVE Certificate Sync End ==="
