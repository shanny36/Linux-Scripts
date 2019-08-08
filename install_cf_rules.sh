#!/bin/bash

## Detect Operating System
function dist-check() {
  if [ -e /etc/centos-release ]; then
    DISTRO="CentOS"
  elif [ -e /etc/debian_version ]; then
    DISTRO=$( lsb_release -is )
  elif [ -e /etc/arch-release ]; then
    DISTRO="Arch"
  elif [ -e /etc/fedora-release ]; then
    DISTRO="Fedora"
  elif [ -e /etc/redhat-release ]; then
    DISTRO="Redhat"
  else
    echo "Your distribution is not supported (yet)."
    exit
  fi
}

## Check distro
dist-check

## Start Installation Of SSH
function install-cf-rules() {
if [ "$DISTRO" == "Debian" ]; then'
  apt-get install ipset iptables-persistent -y
  ipset create cf hash:net
  for x in $(curl https://www.cloudflare.com/ips-v4); do ipset add cf $x; done
  iptables -A INPUT -m set --match-set cf src -p tcp -m multiport --dports http,https -j ACCEPT
  iptables-save > /etc/iptables/rules.v4
elif [ "$DISTRO" == "Ubuntu" ]; then'
  apt-get install ipset iptables-persistent -y
  ipset create cf hash:net
  for x in $(curl https://www.cloudflare.com/ips-v4); do ipset add cf $x; done
  iptables -A INPUT -m set --match-set cf src -p tcp -m multiport --dports http,https -j ACCEPT
  iptables-save > /etc/iptables/rules.v4
elif [ "$DISTRO" == "Rasbian" ]; then'
  apt-get install ipset iptables-persistent -y
  ipset create cf hash:net
  for x in $(curl https://www.cloudflare.com/ips-v4); do ipset add cf $x; done
  iptables -A INPUT -m set --match-set cf src -p tcp -m multiport --dports http,https -j ACCEPT
  iptables-save > /etc/iptables/rules.v4
fi

## Run The Function
install-cf-rules
