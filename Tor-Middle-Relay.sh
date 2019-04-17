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
        apt-get install build-essential haveged linux-headers-$(uname -r) iptables-persistent fail2ban tor -y
        apt-get autoremove -y
        apt-get clean -y
        service fail2ban start
        echo 'Nickname Tor
        ORPort 443
        ExitRelay 0
        SocksPort 0
        ControlSocket 0
        ContactInfo tor@tor.com' >> /etc/sysctl.conf
        systemctl restart tor
        
    elif [ "$DISTRO" == "Debian" ]; then
        apt-get update
        apt-get upgrade -y
        apt-get dist-upgrade -y
        apt-get install build-essential haveged linux-headers-$(uname -r) iptables-persistent fail2ban tor -y
        apt-get autoremove -y
        apt-get clean -y
        service fail2ban start
        echo 'Nickname Tor
        ORPort 443
        ExitRelay 0
        SocksPort 0
        ControlSocket 0
        ContactInfo tor@tor.com' >> /etc/sysctl.conf
        systemctl restart tor
        
    elif [ "$DISTRO" == "CentOS" ]; then
        yum update -y
        yum install epel-release haveged kernel-devel -y
        yum groupinstall 'Development Tools' -y
        
    fi


    if [ "$DISTRO" == "CentOS" ]; then
        systemctl start firewalld
        firewall-cmd --zone=public --add-port=$SERVER_PORT/udp
        firewall-cmd --zone=trusted --add-source=$PRIVATE_SUBNET
        firewall-cmd --permanent --zone=public --add-port=$SERVER_PORT/udp
        firewall-cmd --permanent --zone=trusted --add-source=$PRIVATE_SUBNET
        firewall-cmd --direct --add-rule ipv4 nat POSTROUTING 0 -s $PRIVATE_SUBNET ! -d $PRIVATE_SUBNET -j SNAT --to $SERVER_HOST
        firewall-cmd --permanent --direct --add-rule ipv4 nat POSTROUTING 0 -s $PRIVATE_SUBNET ! -d $PRIVATE_SUBNET -j SNAT --to $SERVER_HOST
    else
        iptables -A INPUT -i lo -j ACCEPT
        iptables -A INPUT -p tcp --dport 22 -j ACCEPT
        iptables -A INPUT -p tcp --dport 9001 -j ACCEPT
        iptables -A INPUT -p tcp --dport 9030 -j ACCEPT
        iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 2/s -j ACCEPT
        iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
        iptables -A INPUT -p icmp -j ACCEPT
        iptables -A INPUT -m limit --limit 5/min -j LOG --log-prefix "iptables denied: " --log-level 7
        iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
        iptables -A INPUT -m state --state INVALID -j DROP
        iptables-save > /etc/iptables/rules.v4
    fi
