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
        echo "Updating package list..."
        apt-get update > /dev/null
        echo "Install Fail2Ban..."
        apt-get install build-essential haveged linux-headers-$(uname -r) fail2ban -y > /dev/null
        cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
        
    elif [ "$DISTRO" == "Debian" ]; then
        echo "Updating package list..."
        apt-get update > /dev/null
        echo "Install Fail2Ban..."
        apt-get install build-essential haveged linux-headers-$(uname -r) fail2ban -y > /dev/null
        cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
        
    elif [ "$DISTRO" == "CentOS" ]; then
        yum update -y
        yum install epel-release haveged kernel-devel -y
        yum groupinstall 'Development Tools' -y
    fi
