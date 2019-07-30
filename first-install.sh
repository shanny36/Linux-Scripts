#!/bin/bash

## Sanity Checks and automagic
function root-check() {
if [[ "$EUID" -ne 0 ]]; then
  echo "Sorry, you need to run this as root"
  exit
fi
}

## Root Check
root-check

function dist-check() {
  if [ -e /etc/debian_version ]; then
    DISTRO=$( lsb_release -is )
  else
    echo "Your distribution is not supported (yet)."
    exit
  fi
}

## Check distro
dist-check

## First Install
function first-install() {
if [ "$DISTRO" == "Debian" ]; then
    apt-get update
    apt-get upgrade -y
    apt-get dist-upgrade -y
    apt-get install build-essential linux-headers-$(uname -r) haveged unattended-upgrades apt-listchanges fail2ban -y
    apt-get clean -y
    apt-get autoremove -y
elif [ "$DISTRO" == "Ubuntu" ]; then
    apt-get update
    apt-get upgrade -y
    apt-get dist-upgrade -y
    apt-get install build-essential linux-headers-$(uname -r) haveged unattended-upgrades apt-listchanges fail2ban -y
    apt-get clean -y
    apt-get autoremove -y
elif [ "$DISTRO" == "Raspbian" ]; then
    apt-get update
    apt-get upgrade -y
    apt-get dist-upgrade -y
    apt-get install build-essential raspberrypi-kernel-headers haveged unattended-upgrades apt-listchanges fail2ban -y
    apt-get clean -y
    apt-get autoremove -y
fi
}

## First Install
first-install

## Function For TCP BBR
function tcp-install() {
if [ "$DISTRO" == "Debian" ]; then
    modprobe tcp_bbr
    echo "tcp_bbr" >> /etc/modules-load.d/modules.conf
    echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf 
    echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
    sysctl -p
    uname -r
    sysctl net.ipv4.tcp_available_congestion_control
    sysctl net.ipv4.tcp_congestion_control
    sysctl net.core.default_qdisc
    lsmod | grep bbr
elif [ "$DISTRO" == "Ubuntu" ]; then
    modprobe tcp_bbr
    echo "tcp_bbr" >> /etc/modules-load.d/modules.conf
    echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf 
    echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
    sysctl -p
    uname -r
    sysctl net.ipv4.tcp_available_congestion_control
    sysctl net.ipv4.tcp_congestion_control
    sysctl net.core.default_qdisc
    lsmod | grep bbr
elif [ "$DISTRO" == "Rasbian" ]; then
    modprobe tcp_bbr
    echo "tcp_bbr" >> /etc/modules-load.d/modules.conf
    echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf 
    echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
    sysctl -p
    uname -r
    sysctl net.ipv4.tcp_available_congestion_control
    sysctl net.ipv4.tcp_congestion_control
    sysctl net.core.default_qdisc
    lsmod | grep bbr
fi
}

## TCP BBR
tcp-install

## Function To WGET the unattended-upgrades Config
function wget-config() {
    wget -q -O /etc/apt/apt.conf.d/50unattended-upgrades "https://raw.githubusercontent.com/complexorganizations/unattended-upgrades/master/config/50unattended-upgrades"
}

## Run The Function
wget-config

## Function For SSH Keys
function ssh-install(){
    mkdir -p /root/.ssh
    chmod 600 /root/.ssh
    echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJouQKvkIhLoCyE1lPheITbyIB6ZyEOmAY6e5jEhX6B prajwalkoirala23@protonmail.com' > /root/.ssh/authorized_keys
    chmod 700 /root/.ssh/authorized_keys
}

## Install the SSH keys
ssh-install
