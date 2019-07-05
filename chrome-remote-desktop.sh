#!/bin/bash

## Check Root
function root-check() {
  if [[ "$EUID" -ne 0 ]]; then
    echo "Hello there non ROOT user, you need to run this as ROOT."
    exit
  fi
}

 ## Root Check
root-check

## Detect Operating System
function dist-check() {
  if [ -e /etc/centos-release ]; then
    DISTRO="CentOS"
  elif [ -e /etc/debian_version ]; then
    DISTRO=$( lsb_release -is )
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

function remote-desktop-compute() {
if [ "$DISTRO" == "Debian" ]; then
    wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
    sudo apt update
    sudo dpkg --install chrome-remote-desktop_current_amd64.deb
    sudo apt install --assume-yes --fix-broken
    sudo DEBIAN_FRONTEND=noninteractive \
    apt install --assume-yes xfce4 desktop-base
    echo "xfce4-session" >~/.chrome-remote-desktop-session
    sudo apt install --assume-yes xscreensaver
    sudo apt install --assume-yes task-xfce-desktop
    sudo systemctl disable lightdm.service
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg --install google-chrome-stable_current_amd64.deb
    sudo apt install --assume-yes --fix-broken
    echo "GO TO https://remotedesktop.google.com/headless"
    echo "Run that command here"
elif [ "$DISTRO" == "Ubuntu" ]; then
    wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
    sudo apt update
    sudo dpkg --install chrome-remote-desktop_current_amd64.deb
    sudo apt install --assume-yes --fix-broken
    sudo DEBIAN_FRONTEND=noninteractive \
    apt install --assume-yes xfce4 desktop-base
    echo "xfce4-session" >~/.chrome-remote-desktop-session
    sudo apt install --assume-yes xscreensaver
    sudo apt install --assume-yes task-xfce-desktop
    sudo systemctl disable lightdm.service
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg --install google-chrome-stable_current_amd64.deb
    sudo apt install --assume-yes --fix-broken
    echo "GO TO https://remotedesktop.google.com/headless"
    echo "Run that command here"
elif [ "$DISTRO" == "Rasbian" ]; then
    wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
    sudo apt update
    sudo dpkg --install chrome-remote-desktop_current_amd64.deb
    sudo apt install --assume-yes --fix-broken
    sudo DEBIAN_FRONTEND=noninteractive \
    apt install --assume-yes xfce4 desktop-base
    echo "xfce4-session" >~/.chrome-remote-desktop-session
    sudo apt install --assume-yes xscreensaver
    sudo apt install --assume-yes task-xfce-desktop
    sudo systemctl disable lightdm.service
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg --install google-chrome-stable_current_amd64.deb
    sudo apt install --assume-yes --fix-broken
    echo "GO TO https://remotedesktop.google.com/headless"
    echo "Run that command here"
elif [ "$DISTRO" == "Kali" ]; then
    wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
    sudo apt update
    sudo dpkg --install chrome-remote-desktop_current_amd64.deb
    sudo apt install --assume-yes --fix-broken
    sudo DEBIAN_FRONTEND=noninteractive \
    apt install --assume-yes xfce4 desktop-base
    echo "xfce4-session" >~/.chrome-remote-desktop-session
    sudo apt install --assume-yes xscreensaver
    sudo apt install --assume-yes task-xfce-desktop
    sudo systemctl disable lightdm.service
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg --install google-chrome-stable_current_amd64.deb
    sudo apt install --assume-yes --fix-broken
    echo "GO TO https://remotedesktop.google.com/headless"
    echo "Run that command here"
fi
}

## Run the command
remote-desktop-compute
