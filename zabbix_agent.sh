#!/bin/bash

# Установка зависимостей
apt-get update
apt-get install -y wget

# Загрузка и установка Zabbix agent
wget https://repo.zabbix.com/zabbix/6.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.2-1+ubuntu20.04_all.deb
dpkg -i zabbix-release_6.2-1+ubuntu20.04_all.deb
apt-get update
apt-get install -y zabbix-agent

# Настройка конфигурационного файла агента
sed -i "s/Server=127.0.0.1/Server=$zabbix_server/g" /etc/zabbix/zabbix_agentd.conf
sed -i "s/ServerActive=127.0.0.1/ServerActive=$zabbix_server/g" /etc/zabbix/zabbix_agentd.conf
sed -i "s/Hostname=Zabbix server/Hostname=$profile/g" /etc/zabbix/zabbix_agentd.conf

# Включение и запуск агента с помощью systemd
systemctl enable zabbix-agent
systemctl start zabbix-agent
