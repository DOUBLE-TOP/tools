#!/bin/bash

echo "-----------------------------------------------------------------------------"
curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/doubletop.sh | bash
echo "-----------------------------------------------------------------------------"

curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/main.sh | bash &>/dev/null
curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/ufw.sh | bash &>/dev/null
curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/docker.sh | bash &>/dev/null

echo "-----------------------------------------------------------------------------"
echo "Установка RPC Sepolia"
echo "-----------------------------------------------------------------------------"

if ! id "geth_sepolia" &>/dev/null; then
    useradd -s /bin/bash -m geth_sepolia
    sudo usermod -aG sudo geth_sepolia
    sudo usermod -aG docker geth_sepolia
    sudo passwd geth_sepolia    
else
    echo "User 'geth_sepolia' already exists."
fi

if [ ! -d "/home/geth_sepolia/eth-docker" ]; then
        sudo -u geth_sepolia git clone https://github.com/eth-educators/eth-docker.git /home/geth_sepolia/eth-docker
    else
        echo "Directory '/home/geth_sepolia/eth-docker' already exists."
fi


sudo -u geth_sepolia cp /home/geth_sepolia/eth-docker/default.env /home/geth_sepolia/eth-docker/.env
sudo -u geth_sepolia sed -i 's/COMPOSE_FILE=.*/COMPOSE_FILE=lighthouse-cl-only.yml:geth.yml:grafana.yml:grafana-shared.yml:el-shared.yml/g' /home/geth_sepolia/eth-docker/.env
sudo -u geth_sepolia sed -i 's/EL_P2P_PORT=.*/EL_P2P_PORT=50303/g' /home/geth_sepolia/eth-docker/.env
sudo -u geth_sepolia sed -i 's/CL_P2P_PORT=.*/CL_P2P_PORT=59000/g' /home/geth_sepolia/eth-docker/.env
sudo -u geth_sepolia sed -i 's/CL_QUIC_PORT=.*/CL_QUIC_PORT=59001/g' /home/geth_sepolia/eth-docker/.env
sudo -u geth_sepolia sed -i 's/GRAFANA_PORT=.*/GRAFANA_PORT=53000/g' /home/geth_sepolia/eth-docker/.env
sudo -u geth_sepolia sed -i 's/EL_RPC_PORT=.*/EL_RPC_PORT=58545/g' /home/geth_sepolia/eth-docker/.env
sudo -u geth_sepolia sed -i 's/EL_WS_PORT=.*/EL_WS_PORT=58546/g' /home/geth_sepolia/eth-docker/.env
sudo -u geth_sepolia sed -i 's/NETWORK=goerli/NETWORK=sepolia/g' /home/geth_sepolia/eth-docker/.env
sudo -u geth_sepolia sed -i 's/RAPID_SYNC_URL=/RAPID_SYNC_URL=\"https:\/\/sepolia.beaconstate.info\"/g' /home/geth_sepolia/eth-docker/.env
sudo -u geth_sepolia sed -i 's/FEE_RECIPIENT=/FEE_RECIPIENT=0xd9264738573E25CB9149de0708b36527d56B59bd/g' /home/geth_sepolia/eth-docker/.env


export COMPOSE_PROJECT_NAME=sepolia
sudo -u geth_sepolia /home/geth_sepolia/eth-docker/ethd up