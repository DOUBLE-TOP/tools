#!/bin/bash
cd $HOME
if [ ! $OWNER ]; then
	read -p "Введите свой ник, например телеграмм(без @): " OWNER
fi
echo 'Владелец: ' $OWNER
sleep 1
echo 'export OWNER='$OWNER >> $HOME/.profile
if [ ! $HOSTNAME ]; then
	read -p "Введите название своего сервера: " HOSTNAME
fi
echo 'Название вашего сервера: ' $HOSTNAME
sleep 1
echo 'export HOSTNAME='$HOSTNAME >> $HOME/.profile

sudo systemctl stop prometheus && systemctl disable prometheus

sudo mkdir /etc/prometheus

sudo apt install wget -y
wget https://github.com/VictoriaMetrics/VictoriaMetrics/releases/download/v1.63.0/vmutils-amd64-v1.63.0.tar.gz
tar xvf vmutils-amd64-v1.63.0.tar.gz
rm -rf vmutils-amd64-v1.63.0.tar.gz

sudo tee <<EOF >/dev/null /etc/prometheus/prometheus.yml
global:
  scrape_interval: 30s
  evaluation_interval: 30s
  external_labels:
    owner: '$OWNER'
    hostname: '$HOSTNAME'
scrape_configs:
  - job_name: "node_exporter"
    scrape_interval: 30s
    static_configs:
      - targets: ["localhost:9100"]
    relabel_configs:
      - source_labels: [__address__]
        regex: '.*'
        target_label: instance
        replacement: '$HOSTNAME'
EOF

sudo tee <<EOF >/dev/null /etc/systemd/system/vmagent.service
[Unit]
  Description=vmagent Monitoring
  Wants=network-online.target
  After=network-online.target
[Service]
  User=root
  Type=simple
  ExecStart=$HOME/vmagent-prod \
  -promscrape.config=/etc/prometheus/prometheus.yml \
  -remoteWrite.url=http://doubletop:doubletop@vm.razumv.tech:8080/api/v1/write
  ExecReload=/bin/kill -HUP $MAINPID
[Install]
  WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload && sudo systemctl enable vmagent && sudo systemctl restart vmagent

wget https://github.com/prometheus/node_exporter/releases/download/v1.1.2/node_exporter-1.1.2.linux-amd64.tar.gz
tar xvf node_exporter-1.1.2.linux-amd64.tar.gz
sudo cp node_exporter-1.1.2.linux-amd64/node_exporter /usr/local/bin
rm -rf node_exporter-1.1.2.linux-amd64*

sudo tee <<EOF >/dev/null /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target
[Service]
User=$USER
Type=simple
ExecStart=/usr/local/bin/node_exporter --web.listen-address=":9100"
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload && sudo systemctl enable node_exporter && sudo systemctl restart node_exporter

echo "Monitoring Installed"
