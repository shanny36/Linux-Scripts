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
    read -rp "Do You Want To Install TCP BBR (y/n): " -e -i n INSTALL_TCPBBR
    read -rp "Do You Want To Install Public SSH Key (y/n): " -e -i n INSTALL_PUBLIC_SSH
    read -rp "Do You Want To Install Private SSH Key (y/n): " -e -i n INSTALL_PRIVATE_SSH

## First Install
function first-install() {
  if [ "$INSTALL_UPDATES" == "y" ]; then
    apt-get update
    apt-get upgrade -y
    apt-get dist-upgrade -y
    apt-get upgrade linux-generic -y
    apt-get upgrade linux-base -y
    apt-get install build-essential linux-headers-$(uname -r) haveged unattended-upgrades apt-listchanges -y
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
function public-ssh-install(){
  if [ "$INSTALL_PUBLIC_SSH" == "y" ]; then
    apt-get install openssh-server fail2ban -y
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
public-ssh-install

function private-ssh-install() {
  if [ "$INSTALL_PRIVATE_SSH" == "y" ]; then
    read -p 'Private SSH Key: ' PRIVATE_SSH_KEY
    eval `ssh-agent`
    mkdir -p /root/.ssh
    chmod 600 /root/.ssh
    echo \
'-----BEGIN OPENSSH PRIVATE KEY-----
$PRIVATE_SSH_KEY
-----END OPENSSH PRIVATE KEY-----' \
>> /root/.ssh/id_rsa
    echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJouQKvkIhLoCyE1lPheITbyIB6ZyEOmAY6e5jEhX6B prajwalkoirala23@protonmail.com' > /root/.ssh/id_rsa.pub
    chmod 600 /root/.ssh/id_rsa
    chmod 644 /root/.ssh/id_rsa.pub
    ssh-add /root/.ssh/id_rsa
    sudo /etc/init.d/ssh restart
  fi
}

private-ssh-install
