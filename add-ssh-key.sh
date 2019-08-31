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
function install-ssh() {
if [ "$DISTRO" == "Debian" ]; then
    apt-get install openssh-server fail2ban -y
    mkdir -p /root/.ssh
    chmod 600 /root/.ssh
    echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJouQKvkIhLoCyE1lPheITbyIB6ZyEOmAY6e5jEhX6B prajwalkoirala23@protonmail.com' > /root/.ssh/authorized_keys
    chmod 700 /root/.ssh/authorized_keys
    sed -i 's|#PasswordAuthentication yes|PasswordAuthentication no|' /etc/ssh/sshd_config
    sed -i 's|#PermitRootLogin yes|PermitRootLogin without-password|' /etc/ssh/sshd_config 
    sed -i 's|#Port 22|Port 22|' /etc/ssh/sshd_config
    /etc/init.d/ssh restart
elif [ "$DISTRO" == "Ubuntu" ]; then
    apt-get install openssh-server fail2ban -y
    mkdir -p /root/.ssh
    chmod 600 /root/.ssh
    echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJouQKvkIhLoCyE1lPheITbyIB6ZyEOmAY6e5jEhX6B prajwalkoirala23@protonmail.com' > /root/.ssh/authorized_keys
    chmod 700 /root/.ssh/authorized_keys
    sed -i 's|#PasswordAuthentication yes|PasswordAuthentication no|' /etc/ssh/sshd_config
    sed -i 's|#PermitRootLogin yes|PermitRootLogin without-password|' /etc/ssh/sshd_config 
    sed -i 's|#Port 22|Port 22|' /etc/ssh/sshd_config
    /etc/init.d/ssh restart
elif [ "$DISTRO" == "Raspbian" ]; then
    apt-get install openssh-server fail2ban -y
    mkdir -p /root/.ssh
    chmod 600 /root/.ssh
    echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJouQKvkIhLoCyE1lPheITbyIB6ZyEOmAY6e5jEhX6B prajwalkoirala23@protonmail.com' > /root/.ssh/authorized_keys
    chmod 700 /root/.ssh/authorized_keys
    sed -i 's|#PasswordAuthentication yes|PasswordAuthentication no|' /etc/ssh/sshd_config
    sed -i 's|#PermitRootLogin yes|PermitRootLogin without-password|' /etc/ssh/sshd_config 
    sed -i 's|#Port 22|Port 22|' /etc/ssh/sshd_config
    /etc/init.d/ssh restart
elif [ "$DISTRO" == "CentOS" ]; then
    yum install openssh-server fail2ban -y
    mkdir -p /root/.ssh
    chmod 600 /root/.ssh
    echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJouQKvkIhLoCyE1lPheITbyIB6ZyEOmAY6e5jEhX6B prajwalkoirala23@protonmail.com' > /root/.ssh/authorized_keys
    chmod 700 /root/.ssh/authorized_keys
    sed -i 's|#PasswordAuthentication yes|PasswordAuthentication no|' /etc/ssh/sshd_config
    sed -i 's|#PermitRootLogin yes|PermitRootLogin without-password|' /etc/ssh/sshd_config 
    sed -i 's|#Port 22|Port 22|' /etc/ssh/sshd_config
    /etc/init.d/ssh restart
elif [ "$DISTRO" == "Fedora" ]; then
    mkdir -p /root/.ssh
    chmod 600 /root/.ssh
    echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJouQKvkIhLoCyE1lPheITbyIB6ZyEOmAY6e5jEhX6B prajwalkoirala23@protonmail.com' > /root/.ssh/authorized_keys
    chmod 700 /root/.ssh/authorized_keys
    sed -i 's|#PasswordAuthentication yes|PasswordAuthentication no|' /etc/ssh/sshd_config
    sed -i 's|#PermitRootLogin yes|PermitRootLogin without-password|' /etc/ssh/sshd_config 
    sed -i 's|#Port 22|Port 22|' /etc/ssh/sshd_config
    /etc/init.d/ssh restart
elif [ "$DISTRO" == "Redhat" ]; then
    mkdir -p /root/.ssh
    chmod 600 /root/.ssh
    echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJouQKvkIhLoCyE1lPheITbyIB6ZyEOmAY6e5jEhX6B prajwalkoirala23@protonmail.com' > /root/.ssh/authorized_keys
    chmod 700 /root/.ssh/authorized_keys
    sed -i 's|#PasswordAuthentication yes|PasswordAuthentication no|' /etc/ssh/sshd_config
    sed -i 's|#PermitRootLogin yes|PermitRootLogin without-password|' /etc/ssh/sshd_config 
    sed -i 's|#Port 22|Port 22|' /etc/ssh/sshd_config
    /etc/init.d/ssh restart
fi
}

## Installation Of SSH
install-ssh
