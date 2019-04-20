### Installing Packages
```
sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get dist-upgrade -y && sudo apt-get autoremove -y && sudo apt-get clean && sudo apt-get install build-essential haveged -y
sudo apt-get install linux-headers-$(uname -r)
sudo apt-get install curl -y
sudo apt-get install shadowsocks-libev -y
sudo apt-get install cron -y
sudo apt-get install screen -y
```
### Install V2Ray
```
cd /etc/shadowsocks-libev/
https://github.com/shadowsocks/v2ray-plugin/releases
dpkg --print-architecture
wget file_for_system
tar -xvzf file_for_system
rm file_for_system
```

# Server Instructions.

### Changing Limits
```
echo '* soft nofile 51200' >> /etc/security/limits.conf
echo '* hard nofile 51200' >> /etc/security/limits.conf
ulimit -n 51200
```
### Removing Systemctl
```
rm /etc/sysctl.conf
```
### Optimizing SS
```
echo 'fs.file-max = 51200
net.core.rmem_max = 67108864
net.core.wmem_max = 67108864
net.core.netdev_max_backlog = 250000
net.core.somaxconn = 4096
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.ip_local_port_range = 10000 65000
net.ipv4.tcp_max_syn_backlog = 8192
net.ipv4.tcp_max_tw_buckets = 5000
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_mem = 25600 51200 102400
net.ipv4.tcp_rmem = 4096 87380 67108864
net.ipv4.tcp_wmem = 4096 65536 67108864
net.ipv4.tcp_mtu_probing = 1
net.ipv4.tcp_congestion_control = hybla' >> /etc/sysctl.conf
```
### Refresh System
```
sysctl -p
```
### Google BBR
```
curl -sSL https://raw.githubusercontent.com/LiveChief/tcp-bbr-install/master/bbr.sh | bash
uname -r
sysctl net.ipv4.tcp_available_congestion_control
sysctl net.ipv4.tcp_congestion_control
sysctl net.core.default_qdisc
lsmod | grep bbr
```

```
sysctl -p
```
### Config
```
nano /etc/shadowsocks-libev/config.json
```

```
{
    "server":"0.0.0.0",
    "server_port":80,
    "password":"PASSWORD",
    "timeout":300,
    "user":"nobody",
    "method":"chacha20-ietf-poly1305",
    "fast_open":false,
    "reuse_port":true,
    "no_delay":true,
    "plugin":"/etc/shadowsocks-libev/file_for_system",
    "plugin_opts":"server"
}
```

# Client Instructions

```
nano /etc/shadowsocks-libev/config.json
```

```
{
    "server":"0.0.0.0",
    "server_port":80,
    "local_port":1080,
    "password":"PASSWORD",
    "method":"chacha20-ietf-poly1305",
    "plugin":"/etc/shadowsocks-libev/file_for_system",
    "plugin_opts":"host=example.com"
}
```

# Startup Script
```
nano /etc/shadowsocks-libev/ss-startup.sh
```

```
#!/bin/sh
if [ -z "$STY" ]; then exec screen -dm -S screenName /bin/bash "$0"; fi
ss-[local|server]
exit 0
```

# Executable
```
chmod a+x /etc/shadowsocks-libev/ss-startup.sh
```

# Crontab
```
crontab -e
@reboot /etc/shadowsocks-libev/ss-startup.sh
```
