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
        apt-get update > /dev/null
        apt-get upgrade -y > /dev/null
        apt-get dist-upgrade -y > /dev/null
        apt-get install build-essential haveged linux-headers-$(uname -r) -y > /dev/null
        apt-get clean -y > /dev/null
        apt-get autoremove -y > /dev/null
        sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf > /dev/null
        sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf > /dev/null
        echo "net.core.default_qdisc = fq" >> /etc/sysctl.conf > /dev/null
        echo "net.ipv4.tcp_congestion_control = bbr" >> /etc/sysctl.conf > /dev/null
        sysctl -p > /dev/null
        uname -r
        sysctl net.ipv4.tcp_available_congestion_control
        sysctl net.ipv4.tcp_congestion_control
        sysctl net.core.default_qdisc
        lsmod | grep bbr
        
    elif [ "$DISTRO" == "Debian" ]; then
        apt-get update > /dev/null
        apt-get upgrade -y > /dev/null
        apt-get dist-upgrade -y > /dev/null
        apt-get install build-essential haveged linux-headers-$(uname -r) -y > /dev/null
        apt-get clean -y > /dev/null
        apt-get autoremove -y > /dev/null
        sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf > /dev/null
        sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf > /dev/null
        echo "net.core.default_qdisc = fq" >> /etc/sysctl.conf > /dev/null
        echo "net.ipv4.tcp_congestion_control = bbr" >> /etc/sysctl.conf > /dev/null
        sysctl -p > /dev/null
        uname -r
        sysctl net.ipv4.tcp_available_congestion_control
        sysctl net.ipv4.tcp_congestion_control
        sysctl net.core.default_qdisc
        lsmod | grep bbr
        
    elif [ "$DISTRO" == "CentOS" ]; then
        yum update -y
        yum install epel-release haveged kernel-devel -y
        yum groupinstall 'Development Tools' -y
    fi
