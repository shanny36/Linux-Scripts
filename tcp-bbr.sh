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
        echo "Systemctl..."
        modprobe tcp_bbr > /dev/null
        echo "tcp_bbr" >> /etc/modules-load.d/modules.conf
        echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf 
        echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
        sysctl -p > /dev/null
        uname -r
        echo "Answer Should Be: kernel verison"
        sysctl net.ipv4.tcp_available_congestion_control
        echo "Answer Should Be: net.ipv4.tcp_available_congestion_control = bbr cubic reno"
        sysctl net.ipv4.tcp_congestion_control
        echo "Answer Should Be: net.ipv4.tcp_congestion_control = bbr"
        sysctl net.core.default_qdisc
        echo "Answer Should Be: net.core.default_qdisc = fq"
        lsmod | grep bbr
        echo "Answer Should Be: tcp_bbr Modugle Started"
        
    elif [ "$DISTRO" == "Debian" ]; then
        echo "Systemctl..."
        modprobe tcp_bbr > /dev/null
        echo "tcp_bbr" >> /etc/modules-load.d/modules.conf
        echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
        echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
        sysctl -p > /dev/null
        uname -r
        echo "Answer Should Be: kernel verison"
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
