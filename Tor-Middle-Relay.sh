#!/bin/bash

if [[ "$EUID" -ne 0 ]]; then
    echo "Sorry, you need to run this as root"
    exit
fi


if [ -e /etc/centos-release ]; then
    DISTRO="CentOS"
elif [ -e /etc/debian_version ]; then
    DISTRO=$( lsb_release -is )
else
    echo "Your distribution is not supported (yet)"
    exit
fi

if [ "$( systemd-detect-virt )" == "openvz" ]; then
    echo "OpenVZ virtualization is not supported"
    exit
fi

    if [ "$DISTRO" == "Ubuntu" ]; then
        apt-get update
        apt-get upgrade -y
        apt-get dist-upgrade -y
        apt-get install build-essential haveged linux-headers-$(uname -r) curl -y
        apt-get autoremove -y
        apt-get clean -y

    elif [ "$DISTRO" == "Debian" ]; then
        apt-get update
        apt-get upgrade -y
        apt-get dist-upgrade -y
        apt-get install build-essential haveged linux-headers-$(uname -r) curl -y
        apt-get autoremove -y
        apt-get clean -y
        echo 'deb http://deb.torproject.org/torproject.org jessie main' >> /etc/apt/sources.list
        apt-get update
        apt-get upgrade -y
        curl https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --import
        gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -
        apt-get update
        apt-get upgrade
        apt-get install tor deb.torproject.org-keyring -y 
        apt-get install tor -y 
  echo 'SocksPort 0
  Log notice file /var/log/tor/notices.log
  RunAsDaemon 1
  DataDirectory /var/lib/tor
  ControlPort 9051
  CookieAuthentication 1
  ORPort 443
  DirPort 80
  ExitPolicy reject *:*
  Nickname TypeYourNicknameHere
  ContactInfo TypeYourEmailHere
  DisableDebuggerAttachment 0' >> /etc/tor/torrc

    elif [ "$DISTRO" == "CentOS" ]; then
        yum update -y
        yum install epel-release haveged kernel-devel -y
        yum groupinstall 'Development Tools' -y
        
    fi
