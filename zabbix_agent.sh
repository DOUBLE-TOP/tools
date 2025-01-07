#!/bin/bash

# sudo apt-get update
# sudo apt-get install -y wget
# sudo apt-get remove --purge zabbix-agent -y
# sudo wget -O zabbix-release_6.2-1+ubuntu20.04_all.deb https://repo.zabbix.com/zabbix/6.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.2-1+ubuntu20.04_all.deb
# sudo dpkg -i zabbix-release_6.2-1+ubuntu20.04_all.deb
# sudo apt-get update
# sudo apt-get install --reinstall zabbix-agent -y
# sudo sed -i "s/Server=127.0.0.1/Server=$zabbix_server/g" /etc/zabbix/zabbix_agentd.conf
# sudo sed -i "s/ServerActive=127.0.0.1/ServerActive=$zabbix_server/g" /etc/zabbix/zabbix_agentd.conf
# sudo sed -i "s/Hostname=Zabbix server/Hostname=$profile/g" /etc/zabbix/zabbix_agentd.conf
# sudo systemctl enable zabbix-agent
# sudo systemctl start zabbix-agent
sudo apt-get update
sudo apt-get install -y wget
sudo apt-get remove --purge zabbix-agent -y
wget -O zabbix-release_6.2-1+ubuntu22.04_all.deb https://repo.zabbix.com/zabbix/6.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.2-1+ubuntu22.04_all.deb
sudo dpkg -i zabbix-release_6.2-1+ubuntu22.04_all.deb
sudo apt-get update
sudo apt-get install --reinstall zabbix-agent -y
sudo sed -i "s/Server=127.0.0.1/Server=$zabbix_server/g" /etc/zabbix/zabbix_agentd.conf
sudo sed -i "s/ServerActive=127.0.0.1/ServerActive=$zabbix_server/g" /etc/zabbix/zabbix_agentd.conf
sudo sed -i "s/Hostname=Zabbix server/Hostname=$profile/g" /etc/zabbix/zabbix_agentd.conf
sudo systemctl enable zabbix-agent
sudo systemctl start zabbix-agent
