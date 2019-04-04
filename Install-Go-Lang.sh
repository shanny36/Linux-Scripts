cd $HOME
ARCHITECTURE='dpkg --print-architecture'
GOVERSION='1.12.1'
FileName='go$GOVERSION.$ARCHITECTURE.tar.gz'
wget https://dl.google.com/go/$FileName
sudo tar -C /usr/local -xvf $FileName
cat >> ~/.bashrc << 'EOF'
export GOPATH=$HOME/go
export PATH=/usr/local/go/bin:$PATH:$GOPATH/bin
EOF
source ~/.bashrc
