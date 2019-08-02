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

## First Install
function first-install() {
    apt-get update
    apt-get upgrade -y
    apt-get dist-upgrade -y
    apt-get upgrade linux-generic -y
    apt-get upgrade linux-base -y
    apt-get install build-essential linux-headers-$(uname -r) haveged unattended-upgrades apt-listchanges fail2ban openssh-server -y
    apt-get install raspberrypi-kernel-headers -y
    apt-get clean -y
    apt-get autoremove -y
}

## First Install
first-install

## Function For TCP BBR
function tcp-install() {
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
    sed -i 's|#PasswordAuthentication yes|PasswordAuthentication no|' /etc/ssh/sshd_config
    sed -i 's|#Port 22|Port 22|' /etc/ssh/sshd_config
    sudo /etc/init.d/ssh restart
}

## Install the SSH keys
ssh-install
