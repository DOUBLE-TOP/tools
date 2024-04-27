#!/bin/bash

# Установка зависимостей
sudo apt-get update
sudo apt-get install -y wget

# Загрузка и установка Zabbix agent
# echo "deb http://security.ubuntu.com/ubuntu focal-security main" | sudo tee /etc/apt/sources.list.d/focal-security.list
# sudo apt-get update
# sudo apt-get install libssl1.1 libldap2-dev -y
sudo wget https://repo.zabbix.com/zabbix/6.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.2-1+ubuntu20.04_all.deb
sudo dpkg -i zabbix-release_6.2-1+ubuntu20.04_all.deb
sudo apt-get update
sudo apt-get install -y zabbix-agent

# Настройка конфигурационного файла агента
sudo sed -i "s/Server=127.0.0.1/Server=$zabbix_server/g" /etc/zabbix/zabbix_agentd.conf
sudo sed -i "s/ServerActive=127.0.0.1/ServerActive=$zabbix_server/g" /etc/zabbix/zabbix_agentd.conf
sudo sed -i "s/Hostname=Zabbix server/Hostname=$profile/g" /etc/zabbix/zabbix_agentd.conf

# Включение и запуск агента с помощью systemd
systemctl enable zabbix-agent
systemctl start zabbix-agent
