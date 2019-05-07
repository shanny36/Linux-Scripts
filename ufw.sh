#!/bin/bash
#

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
        apt-get install build-essential haveged linux-headers-$(uname -r) ufw -y
        apt-get autoremove -y
        apt-get clean -y
        ufw enable
        ufw default reject incoming
        ufw default reject outgoing
        ufw allow out on wg0
        ufw allow out 51820/udp #Outgoing
        ufw allow 51820/udp #Incomming
        echo "ufw disable" To Disable
        echo "ufw status verbose" For Status 
        echo "ufw status numbered" To List
        echo "ufw delete #" To Delete
        echo "ufw reset" To Reset
        
    elif [ "$DISTRO" == "Debian" ]; then
        apt-get update
        apt-get upgrade -y
        apt-get dist-upgrade -y
        apt-get install build-essential haveged linux-headers-$(uname -r) ufw -y
        apt-get autoremove -y
        apt-get clean -y
        ufw enable
        ufw default reject incoming
        ufw default reject outgoing
        ufw allow out on wg0
        ufw allow out 51820/udp #Outgoing
        ufw allow 51820/udp #Incomming
        echo "ufw disable" To Disable
        echo "ufw status verbose" For Status 
        echo "ufw status numbered" To List
        echo "ufw delete #" To Delete
        echo "ufw reset" To Reset
        
    elif [ "$DISTRO" == "CentOS" ]; then
        yum update -y
        yum install epel-release haveged kernel-devel ufw -y
        yum groupinstall 'Development Tools' -y
        ufw enable
        ufw default reject incoming
        ufw default reject outgoing
        ufw allow out on wg0
        ufw allow out 51820/udp #Outgoing
        ufw allow 51820/udp #Incomming
        echo "ufw disable" To Disable
        echo "ufw status verbose" For Status 
        echo "ufw status numbered" To List
        echo "ufw delete #" To Delete
        echo "ufw reset" To Reset
    fi