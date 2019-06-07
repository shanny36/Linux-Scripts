#!/bin/bash

if [[ "$EUID" -ne 0 ]]; then
    echo "Sorry, you need to run this as root"
    exit
fi

if [ -e /etc/centos-release ]; then
    DISTRO="CentOS"
elif [ -e /etc/debian_version ]; then
    DISTRO="Debian"
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

    if [ "$DISTRO" == "Debian" ]; then
        echo "Updating package list..."
        apt-get update > /dev/null
        echo "Upgrading package list..."
        apt-get upgrade -y > /dev/null
        echo "Upgrading Dist list..."
        apt-get dist-upgrade -y > /dev/null
        echo "Build Essential..."
        apt-get install build-essential linux-headers-$(uname -r) haveged -y > /dev/null
        echo "Clean..."
        apt-get clean -y > /dev/null
        echo "Autoremove..."
        apt-get autoremove -y > /dev/null
        
    elif [ "$DISTRO" == "CentOS" ]; then
        yum update -y
        yum install epel-release haveged kernel-devel -y
        yum groupinstall 'Development Tools' -y
    fi
