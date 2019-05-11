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

    if [ "$DISTRO" == "Ubuntu" ]; then
        apt-get remove --purge wireguard -y
        rm -rf etc/wireguard
        rm /etc/wireguard/wg0.conf
        
    elif [ "$DISTRO" == "Debian" ]; then
        apt-get remove --purge wireguard -y
        rm -rf etc/wireguard
        rm /etc/wireguard/wg0.conf
        
    elif [ "$DISTRO" == "CentOS" ]; then
        yum update -y
        yum install epel-release haveged kernel-devel curl -y
        yum groupinstall 'Development Tools' -y
        yum install python3 python3-pip -y
    fi
