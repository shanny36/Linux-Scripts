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

## Detect OS
function dist-check() {
  if [ -e /etc/centos-release ]; then
    DISTRO="CentOS"
  elif [ -e /etc/debian_version ]; then
    DISTRO=$( lsb_release -is )
  elif [ -e /etc/arch-release ]; then
    DISTRO="Arch"
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
function install-updates
    if [ "$DISTRO" == "Debian" ]; then
      apt-get update
      apt-get upgrade -y
      apt-get dist-upgrade -y
      apt-get install build-essential linux-headers-$(uname -r) haveged unattended-upgrades apt-listchanges -y
      wget -q -O /etc/apt/apt.conf.d/50unattended-upgrades "https://raw.githubusercontent.com/LiveChief/unattended-upgrades/master/config/50unattended-upgrades"
      apt-get clean -y
      apt-get autoremove -y
    elif [ "$DISTRO" == "Ubuntu" ]; then
      apt-get update
      apt-get upgrade -y
      apt-get dist-upgrade -y
      apt-get install build-essential linux-headers-$(uname -r) haveged unattended-upgrades apt-listchanges -y
      wget -q -O /etc/apt/apt.conf.d/50unattended-upgrades "https://raw.githubusercontent.com/LiveChief/unattended-upgrades/master/config/50unattended-upgrades"
      apt-get clean -y
      apt-get autoremove -y
    elif [ "$DISTRO" == "Raspbian" ]; then
      apt-get update
      apt-get upgrade -y
      apt-get dist-upgrade -y
      apt-get install build-essential linux-headers-$(uname -r) haveged unattended-upgrades apt-listchanges -y
      wget -q -O /etc/apt/apt.conf.d/50unattended-upgrades "https://raw.githubusercontent.com/LiveChief/unattended-upgrades/master/config/50unattended-upgrades"
      apt-get clean -y
      apt-get autoremove -y
    elif [ "$DISTRO" == "CentOS" ]; then
      yum update -y
      yum install epel-release haveged kernel-devel -y
      yum groupinstall 'Development Tools' -y
    elif [ "$DISTRO" == "Fedora" ]; then
      dnf update
    elif [ "$DISTRO" == "Redhat" ]; then
      dnf update -y
    fi
}
