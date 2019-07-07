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
    cd ~
    rm ~/.ssh/authorized_keys
    pwd
    mkdir .ssh
    cd .ssh
    echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJouQKvkIhLoCyE1lPheITbyIB6ZyEOmAY6e5jEhX6B prajwalkoirala23@protonmail.com' >> ~/.ssh/authorized_keys
    chmod 700 ~/.ssh/
    chmod 600 ~/.ssh/authorized_keys
    echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config
    echo 'Port 22' >> /etc/ssh/sshd_config
    sudo /etc/init.d/ssh restart
elif [ "$DISTRO" == "Ubuntu" ]; then
    cd ~
    rm ~/.ssh/authorized_keys
    pwd
    mkdir .ssh
    cd .ssh
    echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJouQKvkIhLoCyE1lPheITbyIB6ZyEOmAY6e5jEhX6B prajwalkoirala23@protonmail.com' >> ~/.ssh/authorized_keys
    chmod 700 ~/.ssh/
    chmod 600 ~/.ssh/authorized_keys
    echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config
    echo 'Port 22' >> /etc/ssh/sshd_config
    sudo /etc/init.d/ssh restart
elif [ "$DISTRO" == "Raspbian" ]; then
    cd ~
    rm ~/.ssh/authorized_keys
    pwd
    mkdir .ssh
    cd .ssh
    echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJouQKvkIhLoCyE1lPheITbyIB6ZyEOmAY6e5jEhX6B prajwalkoirala23@protonmail.com' >> ~/.ssh/authorized_keys
    chmod 700 ~/.ssh/
    chmod 600 ~/.ssh/authorized_keys
    echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config
    echo 'Port 22' >> /etc/ssh/sshd_config
    sudo /etc/init.d/ssh restart
elif [ "$DISTRO" == "CentOS" ]; then
    cd ~
    rm ~/.ssh/authorized_keys
    pwd
    mkdir .ssh
    cd .ssh
    echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJouQKvkIhLoCyE1lPheITbyIB6ZyEOmAY6e5jEhX6B prajwalkoirala23@protonmail.com' >> ~/.ssh/authorized_keys
    chmod 700 ~/.ssh/
    chmod 600 ~/.ssh/authorized_keys
    echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config
    echo 'Port 22' >> /etc/ssh/sshd_config
    systemctl restart sshd.service
elif [ "$DISTRO" == "Fedora" ]; then
    cd ~
    rm ~/.ssh/authorized_keys
    pwd
    mkdir .ssh
    cd .ssh
    echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJouQKvkIhLoCyE1lPheITbyIB6ZyEOmAY6e5jEhX6B prajwalkoirala23@protonmail.com' >> ~/.ssh/authorized_keys
    chmod 700 ~/.ssh/
    chmod 600 ~/.ssh/authorized_keys
    echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config
    echo 'Port 22' >> /etc/ssh/sshd_config
    sudo /etc/init.d/ssh restart
elif [ "$DISTRO" == "Redhat" ]; then
    cd ~
    rm ~/.ssh/authorized_keys
    pwd
    mkdir .ssh
    cd .ssh
    echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJouQKvkIhLoCyE1lPheITbyIB6ZyEOmAY6e5jEhX6B prajwalkoirala23@protonmail.com' >> ~/.ssh/authorized_keys
    chmod 700 ~/.ssh/
    chmod 600 ~/.ssh/authorized_keys
    echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config
    echo 'Port 22' >> /etc/ssh/sshd_config
    sudo /etc/init.d/ssh restart
fi
}

## Installation Of SSH
install-ssh
