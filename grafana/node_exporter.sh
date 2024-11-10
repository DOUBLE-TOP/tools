#!/bin/bash

#Удаляем node_exporter
sudo systemctl stop node_exporter && systemctl disable node_exporter
sudo apt-get remove prometheus-node-exporter
sudo apt-get purge prometheus-node-exporter
sudo apt-get autoremove

#Удаляем prometheus
sudo systemctl stop prometheus && systemctl disable prometheus
sudo apt-get remove prometheus
sudo rm -rf /etc/prometheus /var/lib/prometheus
sudo apt-get autoremove

#Устанавливаем node_exporter
sudo apt-get update
sudo apt-get install prometheus-node-exporter -y
sudo systemctl enable node_exporter && sudo systemctl restart node_exporter
