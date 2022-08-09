#!/bin/bash
cat <<EOF | tee -a /etc/prometheus/prometheus.yml
  - job_name: "substrate"
    scrape_interval: 30s
    static_configs:
      - targets: ["localhost:9615"]
    relabel_configs:
      - source_labels: [__address__]
        regex: '.*'
        target_label: instance
        replacement: '$HOSTNAME'
EOF

sudo systemctl restart vmagent
