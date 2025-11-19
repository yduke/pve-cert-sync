# PVE-Cert-Sync

## 注意
本脚本仅供本人使用，如果你想适配你的本地服务器，需要fork后修改：
install.sh  中的  `REPO_URL`

pve-cert-sync.sh 中的 `ACME_SERVER` `DOMAIN`

然后将运行脚本改成你自己的github repo内的文件地址。

---

## 简介

这个脚本解决了局域网多个服务器使用IPV6公网，在每一台服务器都需要搭建ACME申请、续期SSL证书的痛点。

解决方法为：

从局域网的ACME服务器（例如 192.168.2.1:16666）申请泛域名，其他服务器使用本脚本自动下载证书，并自动更新 PVE Web / 任意Debian Web界面证书。
一个典型的例子是，使用Lucky(或同类工具)自动申请续签SSL证书，且将新证书文件映射到路径，并提供一个Web服务供局域网访问。

## 功能

- 自动从 ACME HTTP 服务下载：
  - yins.top.pem（fullchain）
  - yins.top.key（privkey）
- 自动检测剩余有效期
  - 若证书剩余 > 20 天，不更新
  - 若 < 20 天，自动更新并重启 PVE 服务
- systemd 定时执行（每天 4 次）
- 开机后自动补执行错过的任务



## 安装方式（PVE / Debian 都支持）

````
bash <(curl -fsSL https://raw.githubusercontent.com/yduke/pve-cert-sync/main/install.sh)
````


## 日志位置

````
/var/log/pve-cert-sync.log
````

使用cat 查看日志

## 手动运行

````
pve-cert-sync
````

## 检查定时任务

````
systemctl status pve-cert-sync.timer
````



## 兼容性

- Proxmox VE 6 / 7 / 8 / 9
- Debian 10/11/12/13
