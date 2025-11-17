# PVE-Cert-Sync

从局域网 ACME（例如 192.168.2.1:16666）自动下载证书，并自动更新 PVE Web / 任意Debian Web界面证书。

## 功能

- 自动从 ACME HTTP 服务下载：
  - yins.top.pem（fullchain）
  - yins.top.key（privkey）
- 自动检测剩余有效期
  - 若证书剩余 > 20 天，不更新
  - 若 < 20 天，自动更新并重启 PVE 服务
- systemd 定时执行（每天 4 次）
- 开机后自动补执行错过的任务

---

## 安装方式（PVE / Debian 都支持）

````
bash <(curl -fsSL https://raw.githubusercontent.com/yduke/pve-cert-sync/main/install.sh)
````
---

## 日志位置

````
/var/log/pve-cert-sync.log
````
---
## 手动运行

````
pve-cert-sync
````
---
## 检查定时任务

````
systemctl status pve-cert-sync.timer
````

---

## 兼容性

- Proxmox VE 6 / 7 / 8 / 9
- Debian 10/11/12/13