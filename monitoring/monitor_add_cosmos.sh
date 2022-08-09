#!/bin/bash

if [ -d $HOME/ki-tools/ ]; then
  sed -i -e "s/^prometheus *=.*/prometheus = true/" $HOME/testnet/kid/config/config.toml
else
  sed -i -e "s/^prometheus *=.*/prometheus = true/" $HOME/.*/config/config.toml
fi

cat <<EOF | tee -a /etc/prometheus/prometheus.yml
  - job_name: "cosmos"
    scrape_interval: 30s
    static_configs:
      - targets: ["localhost:26660"]
    relabel_configs:
      - source_labels: [__address__]
        regex: '.*'
        target_label: instance
        replacement: '$HOSTNAME'
EOF

sudo systemctl restart vmagent
