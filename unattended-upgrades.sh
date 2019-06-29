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
  else
    echo "Your distribution is not supported (yet)."
    exit
  fi
}

## Check distro
dist-check

function install-unattended() {
  if [ "$DISTRO" == "Ubuntu" ]; then
    apt-get update
    apt-get upgrade -y
    apt-get install unattended-upgrades apt-listchanges -y
    apt-get autoremove -y
    apt-get clean -y
    wget -q -O /etc/apt/apt.conf.d/50unattended-upgrades "https://raw.githubusercontent.com/LiveChief/unattended-upgrades/master/config/50unattended-upgrades"
  elif [ "$DISTRO" == "Debian" ]; then
    apt-get update
    apt-get upgrade -y
    apt-get install unattended-upgrades apt-listchanges -y
    apt-get autoremove -y
    apt-get clean -y
    wget -q -O /etc/apt/apt.conf.d/50unattended-upgrades "https://raw.githubusercontent.com/LiveChief/unattended-upgrades/master/config/50unattended-upgrades"
  elif [ "$DISTRO" == "Raspbian" ]; then
    apt-get update
    apt-get upgrade -y
    apt-get install unattended-upgrades apt-listchanges -y
    apt-get autoremove -y
    apt-get clean -y
    wget -q -O /etc/apt/apt.conf.d/50unattended-upgrades "https://raw.githubusercontent.com/LiveChief/unattended-upgrades/master/config/50unattended-upgrades"
    elif [ "$DISTRO" == "CentOS" ]; then
    yum update -y
    yum install epel-release haveged kernel-devel -y
    yum groupinstall 'Development Tools' -y
  fi
}

## Unattended System Update
install-unattended
