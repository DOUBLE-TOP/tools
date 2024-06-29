#!/bin/bash
sudo apt update
sudo apt install mc jq curl build-essential git wget git lz4 -y
sudo rm -rf /usr/local/go
curl https://dl.google.com/go/go1.22.4.linux-amd64.tar.gz | sudo tar -C /usr/local -zxvf -

cat <<'EOF' >>$HOME/.profile
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export GO111MODULE=on
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
EOF

source $HOME/.profile
sleep 1
