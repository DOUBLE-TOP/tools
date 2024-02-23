#!/bin/bash

function install_openssl() {
    git clone https://github.com/openssl/openssl.git
    cd openssl/
    ./config
    make -j`nproc`
    sudo make install
    ldconfig /usr/local/lib64/
    openssl version
}

install_openssl
