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

## Start Installation Of PageSpeed
function install-pagespeed() {
  if [ "$DISTRO" == "Ubuntu" ]; then
      wget https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.deb
      sudo dpkg -i mod-pagespeed-*.deb
      apt-get -f install
      rm mod-pagespeed-stable_current_amd64.deb
  elif [ "$DISTRO" == "Debian" ]; then
      wget https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.deb
      sudo dpkg -i mod-pagespeed-*.deb
      apt-get -f install
      rm mod-pagespeed-stable_current_amd64.deb
  elif [ "$DISTRO" == "Rasbian" ]; then
      wget https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.deb
      sudo dpkg -i mod-pagespeed-*.deb
      apt-get -f install
      rm mod-pagespeed-stable_current_amd64.deb
fi
}

## Install Pagespeed
install-pagespeed

## Restart Apache2
function apache-restart() {
if pgrep systemd-journal; then
  systemctl enable apache2
  systemctl restart apache2
else
   service apache2 restart
fi
}

## Run Apache2 Restart
apache-restart
