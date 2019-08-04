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

    read -rp "Do You Want To Install Updates (y/n): " -e -i y INSTALL_UPDATES
    read -rp "Do You Want To Install TCP BBR (y/n): " -e -i y INSTALL_TCPBBR
    read -rp "Do You Want To Install SSH Key (y/n): " -e -i y INSTALL_SSH

## First Install
function first-install() {
  if [ "$INSTALL_UPDATES" == "y" ]; then
    apt-get update
    apt-get upgrade -y
    apt-get dist-upgrade -y
    apt-get upgrade linux-generic -y
    apt-get upgrade linux-base -y
    apt-get install build-essential linux-headers-$(uname -r) haveged unattended-upgrades apt-listchanges fail2ban openssh-server -y
    apt-get install raspberrypi-kernel-headers -y
    apt-get clean -y
    apt-get autoremove -y
    wget -q -O /etc/apt/apt.conf.d/50unattended-upgrades "https://raw.githubusercontent.com/complexorganizations/unattended-upgrades/master/config/50unattended-upgrades"
  fi
}

## First Install
first-install

## Function For TCP BBR
function tcp-install() {
  if [ "$INSTALL_TCPBBR" == "y" ]; then
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

## Function For SSH Keys
function ssh-install(){
  if [ "$INSTALL_SSH" == "y" ]; then
    mkdir -p /root/.ssh
    chmod 600 /root/.ssh
    echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJouQKvkIhLoCyE1lPheITbyIB6ZyEOmAY6e5jEhX6B prajwalkoirala23@protonmail.com' > /root/.ssh/authorized_keys
    chmod 700 /root/.ssh/authorized_keys
    sed -i 's|#PasswordAuthentication yes|PasswordAuthentication no|' /etc/ssh/sshd_config
    sed -i 's|#Port 22|Port 22|' /etc/ssh/sshd_config
    sudo /etc/init.d/ssh restart
  fi
}

## Install the SSH keys
ssh-install
