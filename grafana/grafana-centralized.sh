#!/bin/bash

echo "-----------------------------------------------------------------------------"
curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/doubletop.sh | bash
echo "-----------------------------------------------------------------------------"
echo "Устанавливаем софт (временной диапазон ожидания ~1 min.)"
echo "-----------------------------------------------------------------------------"

sudo systemctl stop prometheus-node-exporter && systemctl disable prometheus-node-exporter
echo "Отключили prometheus-node-exporter (если он был)"

sudo apt-get remove prometheus-node-exporter -y &>/dev/null
sudo apt-get purge prometheus-node-exporter -y &>/dev/null
sudo apt-get autoremove -y &>/dev/null
echo "Удалили prometheus-node-exporter (если он был)"

sudo systemctl stop prometheus && systemctl disable prometheus
echo "Отключили prometheus (если он был)"

sudo apt-get remove prometheus -y &>/dev/null
sudo rm -rf /etc/prometheus /var/lib/prometheus
sudo apt-get autoremove -y
echo "Удалили prometheus (если он был)"

sudo apt-get update
sudo apt-get install prometheus-node-exporter -y
echo "Ставим prometheus-node-exporter"
sudo systemctl enable prometheus-node-exporter && sudo systemctl restart prometheus-node-exporter
echo "Включаем prometheus-node-exporter"
echo "Весь необходимый софт установлен"
echo "-----------------------------------------------------------------------------"

# Prompt user for API key
read -p "Введите API ключ: " api_key
read -p "Введите имя сервера для удобства (необязательно, латиницей до 32 символов, -._ можно юзать): " nodename

# API endpoint
url="https://nodes.doubletop.io/api/registerServer"

# Send POST request and capture response
response=$(curl -s -X POST "$url" \
    -H "Content-Type: application/json" \
    -d "{\"apikey\": \"$api_key\", \"addToMonitoring\": 1, \"nodename\": \"$nodename\"}")

# Extract message and error fields
message=$(echo "$response" | jq -r '.message')
error=$(echo "$response" | jq -r '.error')

# Check the response message
if [[ "$message" == "ok" ]]; then
    echo "Сервер добавлен в мониторинг"
else
    echo "Ошибка: $error"
fi
