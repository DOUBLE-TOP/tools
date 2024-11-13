#!/bin/bash

#Устанавливаем Prometheus
sudo apt install prometheus
apt install libfontconfig1

sudo tee <<EOF >/dev/null /etc/prometheus/prometheus.yml
global:
  scrape_interval:     15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'Nodes'
    scrape_interval: 30s
    static_configs:
      
      - targets:
          - '$(curl -s ipv4.icanhazip.com):9100'
        labels:
          instance: '$(curl -s ipv4.icanhazip.com)'
          nodename: 'MainServer'
EOF

sudo systemctl restart prometheus
sudo systemctl enable prometheus

#Устанавливаем Grafana
wget https://dl.grafana.com/oss/release/grafana_6.4.3_amd64.deb
dpkg -i grafana_6.4.3_amd64.deb

sudo sed -i 's/;http_port = 3000/http_port = 3002/' /etc/grafana/grafana.ini

sudo systemctl enable grafana-server
sudo systemctl restart grafana-server

rm -rf grafana_6.4.3_amd64.deb