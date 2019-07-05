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

## Start Installation
function install-pihole() {
    if [ "$DISTRO" == "Debian" ]; then
        apt-get update
        apt-get upgrade -y
        apt-get dist-upgrade -y
        apt-get install build-essential haveged linux-headers-$(uname -r) curl -y
        apt-get autoremove -y
        apt-get clean -y
        curl -sSL https://install.pi-hole.net | bash
    elif [ "$DISTRO" == "Ubuntu" ]; then
        apt-get update
        apt-get upgrade -y
        apt-get dist-upgrade -y
        apt-get install build-essential haveged linux-headers-$(uname -r) curl -y
        apt-get autoremove -y
        apt-get clean -y
        curl -sSL https://install.pi-hole.net | bash
    elif [ "$DISTRO" == "Rasbian" ]; then
        apt-get update
        apt-get upgrade -y
        apt-get dist-upgrade -y
        apt-get install build-essential haveged linux-headers-$(uname -r) curl -y
        apt-get autoremove -y
        apt-get clean -y
        curl -sSL https://install.pi-hole.net | bash
    elif [ "$DISTRO" == "Arch" ]; then
        apt-get update
        apt-get upgrade -y
        apt-get dist-upgrade -y
        apt-get install build-essential haveged linux-headers-$(uname -r) curl -y
        apt-get autoremove -y
        apt-get clean -y
        curl -sSL https://install.pi-hole.net | bash
    elif [ "$DISTRO" == "Fedora" ]; then
        apt-get update
        apt-get upgrade -y
        apt-get dist-upgrade -y
        apt-get install build-essential haveged linux-headers-$(uname -r) curl -y
        apt-get autoremove -y
        apt-get clean -y
        curl -sSL https://install.pi-hole.net | bash
    elif [ "$DISTRO" == "Redhat" ]; then
        apt-get update
        apt-get upgrade -y
        apt-get dist-upgrade -y
        apt-get install build-essential haveged linux-headers-$(uname -r) curl -y
        apt-get autoremove -y
        apt-get clean -y
        curl -sSL https://install.pi-hole.net | bash
    elif [ "$DISTRO" == "CentOS" ]; then
        yum update -y
        yum install epel-release haveged kernel-devel curl -y
        yum groupinstall 'Development Tools' -y
        curl -sSL https://install.pi-hole.net | bash
    fi
}
## Install Pi-Hole
install-pihole
