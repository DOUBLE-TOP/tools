#!/bin/bash
function create_user_geth {
    if ! id "geth" &>/dev/null; then
        useradd -s /bin/bash -m geth
        sudo usermod -aG sudo geth
        sudo usermod -aG docker geth
        echo "geth ALL=(ALL) NOPASSWD: /usr/bin/sudo" | sudo tee -a /etc/sudoers
    else
        echo "User 'geth' already exists."
    fi
}

function update_compose_v2 {
    mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor --yes -o /etc/apt/keyrings/docker.gpg
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update
    apt-get install -y docker-compose-plugin
}

function src_geth_client {
    if [ ! -d "/home/geth/eth-docker" ]; then
        sudo -u geth git clone https://github.com/eth-educators/eth-docker.git /home/geth/eth-docker
    else
        echo "Directory '/home/geth/eth-docker' already exists."
    fi
}


function config_geth_client {
    sudo -u geth cp /home/geth/eth-docker/default.env /home/geth/eth-docker/.env
    sudo -u geth sed -i 's/COMPOSE_FILE=teku.yml:besu.yml:deposit-cli.yml/COMPOSE_FILE=lighthouse-cl-only.yml:geth.yml:grafana.yml:grafana-shared.yml:el-shared.yml/g' /home/geth/eth-docker/.env
    sudo -u geth sed -i 's/EL_RPC_PORT=8545/EL_RPC_PORT=58545/g' /home/geth/eth-docker/.env
    sudo -u geth sed -i 's/EL_WS_PORT=8546/EL_WS_PORT=58546/g' /home/geth/eth-docker/.env
    sudo -u geth sed -i 's/EL_P2P_PORT=30303/EL_P2P_PORT=50303/g' /home/geth/eth-docker/.env
    sudo -u geth sed -i 's/GRAFANA_PORT=3000/GRAFANA_PORT=5000/g' /home/geth/eth-docker/.env
    sudo -u geth sed -i 's/NETWORK=goerli/NETWORK=sepolia/g' /home/geth/eth-docker/.env
    sudo -u geth sed -i 's/RAPID_SYNC_URL=/RAPID_SYNC_URL=\"https:\/\/sepolia.beaconstate.info\"/g' /home/geth/eth-docker/.env
    sudo -u geth sed -i 's/FEE_RECIPIENT=/FEE_RECIPIENT=0xe868bE65C50b61E81A3fC5cB5A7916090B05eb2A/g' /home/geth/eth-docker/.env
}

function ethd_up {
    sudo -u geth /home/geth/eth-docker/ethd up
}

function ethd_down {
    sudo -u geth /home/geth/eth-docker/ethd down
}

function main {
    create_user_geth
    update_compose_v2
    src_geth_client
    config_geth_client
    ethd_up
}

main
