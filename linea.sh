#!/bin/bash

mkdir linea-sepolia-node
cd linea-sepolia-node
curl -O https://docs.linea.build/files/geth/sepolia/docker-compose.yml
curl -O https://docs.linea.build/files/geth/sepolia/genesis.json

# Replace ports in command arguments (like --http.port=8545)
#sed -i 's/--http\.port=\([0-9]\{4,5\}\)/--http.port=3\1/g' docker-compose.yml
# Replace ports in the ports section
sed -i '/ports:/,/^[[:space:]]*[^-[:space:]]/ s/30303:/55303:/g' docker-compose.yml
sed -i '/ports:/,/^[[:space:]]*[^-[:space:]]/ s/8545:/55545:/g' docker-compose.yml
sed -i '/ports:/,/^[[:space:]]*[^-[:space:]]/ s/8546:/55546:/g' docker-compose.yml

docker compose up -d


ip=$(hostname -I | awk '{print $1}')
echo "RPC Linea Sepolia запущена. Смотреть логи docker logs -f linea-sepolia-node-node-1"
echo ""
echo "HTTP Linea: http://$ip:55545"
echo "WS Linea: ws://$ip:55546"
