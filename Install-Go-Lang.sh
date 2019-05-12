cd $HOME
dpkg --print-architecture
FileName='https://golang.org/dl/$FileName'
wget https://dl.google.com/go/$FileName
sudo tar -C /usr/local -xvf $FileName
cat >> ~/.bashrc << 'EOF'
export GOPATH=$HOME/go
export PATH=/usr/local/go/bin:$PATH:$GOPATH/bin
EOF
source ~/.bashrc
