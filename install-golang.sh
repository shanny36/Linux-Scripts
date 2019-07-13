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

function dist-check() {
    if [ -e /etc/centos-release ]; then
        DISTRO="CentOS"
    elif [ -e /etc/debian_version ]; then
        DISTRO=$(lsb_release -is)
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
}

## Check distro
dist-check

CHECK_ARCHITECTURE=$(dpkg --print-architecture)
FILE_NAME=$(go1.12.7.linux-$CHECK_ARCHITECTURE.tar.gz)

## Start Installation
function install-golang() {
    if [ "$DISTRO" == "Raspbian" ]; then
        cd $HOME
        wget https://dl.google.com/go/$FILE_NAME
        sudo tar -C /usr/local -xvf $FILE_NAME
        cat >>~/.bashrc <<'EOF'
export GOPATH=$HOME/go
export PATH=/usr/local/go/bin:$PATH:$GOPATH/bin
EOF
        source ~/.bashrc
    elif [ "$DISTRO" == "Debian" ]; then
        cd $HOME
        wget https://dl.google.com/go/$FILE_NAME
        sudo tar -C /usr/local -xvf $FILE_NAME
        cat >>~/.bashrc <<'EOF'
export GOPATH=$HOME/go
export PATH=/usr/local/go/bin:$PATH:$GOPATH/bin
EOF
        source ~/.bashrc
    elif [ "$DISTRO" == "Ubuntu" ]; then
        cd $HOME
        wget https://dl.google.com/go/$FILE_NAME
        sudo tar -C /usr/local -xvf $FILE_NAME
        cat >>~/.bashrc <<'EOF'
export GOPATH=$HOME/go
export PATH=/usr/local/go/bin:$PATH:$GOPATH/bin
EOF
        source ~/.bashrc
    elif [ "$DISTRO" == "CentOS" ]; then
        cd $HOME
        wget https://dl.google.com/go/$FILE_NAME
        sudo tar -C /usr/local -xvf $FILE_NAME
        cat >>~/.bashrc <<'EOF'
export GOPATH=$HOME/go
export PATH=/usr/local/go/bin:$PATH:$GOPATH/bin
EOF
        source ~/.bashrc
    elif [ "$DISTRO" == "Arch" ]; then
        cd $HOME
        wget https://dl.google.com/go/$FILE_NAME
        sudo tar -C /usr/local -xvf $FILE_NAME
        cat >>~/.bashrc <<'EOF'
export GOPATH=$HOME/go
export PATH=/usr/local/go/bin:$PATH:$GOPATH/bin
EOF
        source ~/.bashrc
    elif [ "$DISTRO" == "Fedora" ]; then
        cd $HOME
        wget https://dl.google.com/go/$FILE_NAME
        sudo tar -C /usr/local -xvf $FILE_NAME
        cat >>~/.bashrc <<'EOF'
export GOPATH=$HOME/go
export PATH=/usr/local/go/bin:$PATH:$GOPATH/bin
EOF
        source ~/.bashrc
    elif [ "$DISTRO" == "Redhat" ]; then
        cd $HOME
        wget https://dl.google.com/go/$FILE_NAME
        sudo tar -C /usr/local -xvf $FILE_NAME
        cat >>~/.bashrc <<'EOF'
export GOPATH=$HOME/go
export PATH=/usr/local/go/bin:$PATH:$GOPATH/bin
EOF
        source ~/.bashrc
    fi
}

## Install
install-golang
