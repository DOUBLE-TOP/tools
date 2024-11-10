#!/bin/bash

#Устанавливаем Prometheus
sudo apt install prometheus

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
sudo systemctl enable grafana-server
sudo systemctl start grafana-server