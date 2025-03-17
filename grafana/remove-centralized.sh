#!/bin/bash

echo "-----------------------------------------------------------------------------"
curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/doubletop.sh | bash
echo "-----------------------------------------------------------------------------"
# Prompt user for API key
read -p "Введите API ключ: " api_key

# API endpoint
url="https://nodes.doubletop.io/api/removeServer"

# Send POST request and capture response
response=$(curl -s -X POST "$url" \
    -H "Content-Type: application/json" \
    -d "{\"apikey\": \"$api_key\"}")

echo "$response"
# Extract message and error fields
message=$(echo "$response" | jq -r '.message')
error=$(echo "$response" | jq -r '.error')

# Check the response message
if [[ "$message" == "ok" ]]; then
    echo "Сервер удален, со временем пропадет из  Графаны (10-15 минут)."
else
    echo "Ошибка: $error"
fi
