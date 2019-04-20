# Install
sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade -y && sudo apt autoremove -y && sudo apt clean && sudo apt install build-essential haveged -y
sudo apt-get install ufw -y

sudo ufw enable
sudo ufw disable
ufw status verbose

# Enable
ufw default reject incoming
ufw default reject outgoing
ufw allow out 443/tcp #Outgoing
ufw allow 22/tcp #Incomming
ufw allow out on tun0

# Delete 
ufw status numbered
ufw delete #

# Reset
sudo ufw reset
