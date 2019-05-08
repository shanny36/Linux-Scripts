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
        echo "Upgrading package list..."
        apt-get upgrade -y > /dev/null
        echo "Upgrading Dist list..."
        apt-get dist-upgrade -y > /dev/null
        echo "Build Essential..."
        apt-get install build-essential haveged linux-headers-$(uname -r) -y > /dev/null
        echo "Update Keneral..."
        apt-get upgrade linux-generic -y > /dev/null
        echo "Clean..."
        apt-get clean -y > /dev/null
        echo "Autoremove..."
        apt-get autoremove -y > /dev/null
        echo " 
        echo "Systemctl..."
        modprobe tcp_bbr > /dev/null
        echo "tcp_bbr" >> /etc/modules-load.d/modules.conf
        echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf 
        echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
        sysctl -p > /dev/null
        uname -r
        echo "should show your kernel verison"
        sysctl net.ipv4.tcp_available_congestion_control
        echo "Answer Should Be: net.ipv4.tcp_available_congestion_control = bbr cubic reno"
        sysctl net.ipv4.tcp_congestion_control
        echo "Answer Should Be: net.ipv4.tcp_congestion_control = bbr"
        sysctl net.core.default_qdisc
        echo "Answer Should Be: net.core.default_qdisc = fq"
        lsmod | grep bbr
        echo "Answer Should Be: tcp_bbr Modugle Started"
        
    elif [ "$DISTRO" == "Debian" ]; then
        echo "Updating package list..."
        apt-get update > /dev/null
        echo "Upgrading package list..."
        apt-get upgrade -y > /dev/null
        echo "Upgrading Dist list..."
        apt-get dist-upgrade -y > /dev/null
        echo "Build Essential..."
        apt-get install build-essential haveged linux-headers-$(uname -r) -y > /dev/null
        echo "Update Keneral..."
        apt-get upgrade linux-base -y > /dev/null
        echo "Clean..."
        apt-get clean -y > /dev/null
        echo "Autoremove..."
        apt-get autoremove -y > /dev/null
        echo "Systemctl..."
        modprobe tcp_bbr > /dev/null
        echo "tcp_bbr" >> /etc/modules-load.d/modules.conf
        echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
        echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
        sysctl -p > /dev/null
        uname -r
        echo "should show your kernel verison"
        sysctl net.ipv4.tcp_available_congestion_control
        echo "Answer Should Be: net.ipv4.tcp_available_congestion_control = bbr cubic reno"
        sysctl net.ipv4.tcp_congestion_control
        echo "Answer Should Be: net.ipv4.tcp_congestion_control = bbr"
        sysctl net.core.default_qdisc
        echo "Answer Should Be: net.core.default_qdisc = fq"
        lsmod | grep bbr
        echo "Answer Should Be: tcp_bbr Modugle Started"
        
    elif [ "$DISTRO" == "CentOS" ]; then
        yum update -y
        yum install epel-release haveged kernel-devel -y
        yum groupinstall 'Development Tools' -y
    fi
