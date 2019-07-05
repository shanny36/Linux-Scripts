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

function install-rocketchat() {
    if [ "$DISTRO" == "Ubuntu" ]; then
        apt-get update
        apt-get upgrade -y
        apt-get dist-upgrade -y
        apt-get install build-essential haveged linux-headers-$(uname -r) snapd -y
        apt-get autoremove -y
        apt-get clean -y
        snap install rocketchat-server
    elif [ "$DISTRO" == "Debian" ]; then
        apt-get update
        apt-get upgrade -y
        apt-get dist-upgrade -y
        apt-get install build-essential haveged linux-headers-$(uname -r) -y
        apt-get autoremove -y
        apt-get clean -y
        apt-get install dirmngr && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5
        echo "deb http://repo.mongodb.org/apt/debian stretch/mongodb-org/3.6 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.6.list
        apt-get update && apt-get install -y curl && curl -sL https://deb.nodesource.com/setup_8.x | sudo bash -
        apt-get install -y build-essential mongodb-org nodejs graphicsmagick
        sudo npm install -g inherits n && sudo n 8.11.3
        curl -L https://releases.rocket.chat/latest/download -o /tmp/rocket.chat.tgz
        tar -xzf /tmp/rocket.chat.tgz -C /tmp
        cd /tmp/bundle/programs/server && npm install
        sudo mv /tmp/bundle /opt/Rocket.Chat
        sudo useradd -M rocketchat && sudo usermod -L rocketchat
        sudo chown -R rocketchat:rocketchat /opt/Rocket.Chat
        echo -e "[Unit]\nDescription=The Rocket.Chat server\nAfter=network.target remote-fs.target nss-lookup.target nginx.target mongod.target\n[Service]\nExecStart=/usr/local/bin/node /opt/Rocket.Chat/main.js\nStandardOutput=syslog\nStandardError=syslog\nSyslogIdentifier=rocketchat\nUser=rocketchat\nEnvironment=MONGO_URL=mongodb://localhost:27017/rocketchat ROOT_URL=http://your-host-name.com-as-accessed-from-internet:3000/ PORT=3000\n[Install]\nWantedBy=multi-user.target" | sudo tee /lib/systemd/system/rocketchat.service
        rm /lib/systemd/system/rocketchat.service
        read -p "Enter Your Domain (www.example.com) please include www if your using it: "  domain	
        echo 'MONGO_URL=mongodb://localhost:27017/rocketchat
        ROOT_URL=http://$domain:3000
        PORT=3000' >> /lib/systemd/system/rocketchat.service
        sudo systemctl enable mongod && sudo systemctl start mongod
        sudo systemctl enable rocketchat && sudo systemctl start rocketchat
    elif [ "$DISTRO" == "Rasbian" ]; then
        apt-get update
        apt-get upgrade -y
        apt-get dist-upgrade -y
        apt-get install build-essential haveged linux-headers-$(uname -r) -y
        apt-get autoremove -y
        apt-get clean -y
        apt-get install dirmngr && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5
        echo "deb http://repo.mongodb.org/apt/debian stretch/mongodb-org/3.6 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.6.list
        apt-get update && apt-get install -y curl && curl -sL https://deb.nodesource.com/setup_8.x | sudo bash -
        apt-get install -y build-essential mongodb-org nodejs graphicsmagick
        sudo npm install -g inherits n && sudo n 8.11.3
        curl -L https://releases.rocket.chat/latest/download -o /tmp/rocket.chat.tgz
        tar -xzf /tmp/rocket.chat.tgz -C /tmp
        cd /tmp/bundle/programs/server && npm install
        sudo mv /tmp/bundle /opt/Rocket.Chat
        sudo useradd -M rocketchat && sudo usermod -L rocketchat
        sudo chown -R rocketchat:rocketchat /opt/Rocket.Chat
        echo -e "[Unit]\nDescription=The Rocket.Chat server\nAfter=network.target remote-fs.target nss-lookup.target nginx.target mongod.target\n[Service]\nExecStart=/usr/local/bin/node /opt/Rocket.Chat/main.js\nStandardOutput=syslog\nStandardError=syslog\nSyslogIdentifier=rocketchat\nUser=rocketchat\nEnvironment=MONGO_URL=mongodb://localhost:27017/rocketchat ROOT_URL=http://your-host-name.com-as-accessed-from-internet:3000/ PORT=3000\n[Install]\nWantedBy=multi-user.target" | sudo tee /lib/systemd/system/rocketchat.service
        rm /lib/systemd/system/rocketchat.service
        read -p "Enter Your Domain (www.example.com) please include www if your using it: "  domain	
        echo 'MONGO_URL=mongodb://localhost:27017/rocketchat
        ROOT_URL=http://$domain:3000
        PORT=3000' >> /lib/systemd/system/rocketchat.service
        sudo systemctl enable mongod && sudo systemctl start mongod
        sudo systemctl enable rocketchat && sudo systemctl start rocketchat
    elif [ "$DISTRO" == "CentOS" ]; then
        yum update -y
        yum install epel-release haveged kernel-devel -y
        yum groupinstall 'Development Tools' -y
        echo -e "[mongodb-org-3.6]\nname=MongoDB Repository\nbaseurl=https://repo.mongodb.org/yum/redhat/7/mongodb-org/3.6/x86_64/\ngpgcheck=1\nenabled=1\ngpgkey=https://www.mongodb.org/static/pgp/server-3.6.asc" | sudo tee /etc/yum.repos.d/mongodb-org-3.6.repo
        sudo yum install -y curl && curl -sL https://rpm.nodesource.com/setup_8.x | sudo bash -
        sudo yum install -y gcc-c++ make mongodb-org nodejs
        sudo yum install -y epel-release && sudo yum install -y GraphicsMagick
        sudo npm install -g inherits n && sudo n 8.11.3
        curl -L https://releases.rocket.chat/latest/download -o /tmp/rocket.chat.tgz
        tar -xzf /tmp/rocket.chat.tgz -C /tmp
        cd /tmp/bundle/programs/server && npm install
        sudo mv /tmp/bundle /opt/Rocket.Chat
        sudo useradd -M rocketchat && sudo usermod -L rocketchat
        sudo chown -R rocketchat:rocketchat /opt/Rocket.Chat
        echo -e "[Unit]\nDescription=The Rocket.Chat server\nAfter=network.target remote-fs.target nss-lookup.target nginx.target mongod.target\n[Service]\nExecStart=/usr/local/bin/node /opt/Rocket.Chat/main.js\nStandardOutput=syslog\nStandardError=syslog\nSyslogIdentifier=rocketchat\nUser=rocketchat\nEnvironment=LD_PRELOAD=/opt/Rocket.Chat/programs/server/npm/node_modules/sharp/vendor/lib/libz.so NODE_ENV=production MONGO_URL=mongodb://localhost:27017/rocketchat ROOT_URL=http://your-host-name.com-as-accessed-from-internet:3000/ PORT=3000\n[Install]\nWantedBy=multi-user.target" | sudo tee /usr/lib/systemd/system/rocketchat.service
        rm /lib/systemd/system/rocketchat.service
        read -p "Enter Your Domain (www.example.com) please include www if your using it: "  domain	
        echo 'MONGO_URL=mongodb://localhost:27017/rocketchat
        ROOT_URL=http://$domain:3000
        PORT=3000' >> /lib/systemd/system/rocketchat.service
        sudo systemctl enable mongod && sudo systemctl start mongod
        sudo systemctl enable rocketchat && sudo systemctl start rocketchat
        sudo firewall-cmd --permanent --add-port=3000/tcp
        sudo systemctl reload firewalld
    fi    
}
## Install RocketChat
install-rocketchat
