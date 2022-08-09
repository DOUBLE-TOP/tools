#/bin/bash

RED="\033[31m"
YELLOW="\033[33m"
GREEN="\033[32m"
NORMAL="\033[0m"

function line {
    echo "-------------------------------------------------------------------"
}

function setup {
  cosmos_prefix "${1}"
  cosmos_denom "${2}"
  cosmos_denom_coef "${3}"
  node_port "${4}"
  rpc_port "${5}"
  exporter_port "${6}"
  valoper "${7}"
  wallet "${8}"
}

function cosmos_prefix {
  COSMOS_PREFIX=${1}
}

function cosmos_denom {
  COSMOS_DENOM=${1}
}

function cosmos_denom_coef {
  COSMOS_DENOM_COEF=${1}
}

function node_port {
  NODE_PORT=${1}
}

function rpc_port {
  RPC_PORT=${1}
}

function exporter_port {
  EXPORTER_PORT=${1}
}

function valoper {
  VALOPER=${1}
}

function wallet {
  WALLET=${1}
}

function install_tools {
  sudo apt update &>/dev/null\
  && sudo apt install git -y &>/dev/null
}

function install_go {
  line
  if [ -f /usr/local/go/bin/go ]; then
      echo -e "$GREEN GO found. Continue...$NORMAL"
  else
      curl -s https://github.com/razumv/helpers/blob/main/tools/install_go.sh | bash &>/dev/null
  fi
}

function source {
  line
  mkdir -p $HOME/exporter \
  && cd $HOME/exporter \
  && git clone https://github.com/solarlabsteam/cosmos-exporter &>/dev/null \
  && cd cosmos-exporter \
  && git fetch &>/dev/null \
  && git checkout v0.3.0 &>/dev/null \
  && go build &>/dev/null
  if [ -f /usr/bin/cosmos-exporter ]; then
      echo -e "$GREEN cosmos-exporter found. Continue...$NORMAL"
  else
      go build
      BUILD="$HOME/exporter/cosmos-exporter"
      if [ -f /usr/bin/cosmos-exporter ]; then
          echo -e "$GREEN cosmos-exporter found. Continue...$NORMAL"
      elif [ -f $BUILD/main ]; then
          sudo cp main /usr/bin/cosmos-exporter
          echo -e "$GREEN cosmos-exporter found. Continue...$NORMAL"
      else
          make all &>/dev/null
      fi
  fi
  line
  echo -e "$GREEN cosmos-exporter built and installed.$NORMAL"
  line
}

function installSource {
    PROJECT="$HOME/exporter/cosmos-exporter"
    if [ -e $PROJECT ]; then
        line
        echo -e "$YELLOW cosmos-exporter folder exists...$NORMAL"
        echo -e "$RED 1$NORMAL -$YELLOW Reinstall cosmos-exporter.$NORMAL"
        echo -e "$RED 2$NORMAL -$YELLOW Do nothing.$NORMAL"
        line
        read -p "Your answer: " ANSWER
        if [ "$ANSWER" == "1" ]; then
            rm -rf $PROJECT
            source
        elif [ "$ANSWER" == "2" ]; then
            line
            echo -e "$YELLOW The option to do nothing is selected. Continue...$NORMAL"
            line
        fi
    else
        source
    fi
}

function binService {
  sudo tee <<EOF >/dev/null /etc/systemd/system/cosmos-exporter-${COSMOS_PREFIX}.service
[Unit]
Description=Cosmos Exporter
After=network-online.target

[Service]
User=${USER}
TimeoutStartSec=0
CPUWeight=95
IOWeight=95
ExecStart=/usr/bin/cosmos-exporter \
--bech-account-prefix=${COSMOS_PREFIX} \
--bech-account-pubkey-prefix=${COSMOS_PREFIX}pub \
--bech-consensus-node-prefix=${COSMOS_PREFIX}valcons \
--bech-consensus-node-pubkey-prefix=${COSMOS_PREFIX}valconspub \
--bech-validator-prefix=${COSMOS_PREFIX}valoper \
--bech-validator-pubkey-prefix=${COSMOS_PREFIX}valoperpub \
--denom=${COSMOS_DENOM} \
--denom-coefficient=${COSMOS_DENOM_COEF} \
--listen-address=localhost:${EXPORTER_PORT} \
--log-level=info \
--node=localhost:${NODE_PORT} \
--tendermint-rpc=http://localhost:${RPC_PORT}
Restart=always
RestartSec=2
LimitNOFILE=800000
KillSignal=SIGTERM

[Install]
WantedBy=multi-user.target
EOF

  sudo systemctl daemon-reload \
  && sudo systemctl enable cosmos-exporter-${COSMOS_PREFIX}  &>/dev/null \
  && sudo systemctl restart cosmos-exporter-${COSMOS_PREFIX}
  echo -e "$GREEN cosmos-exporter-${COSMOS_PREFIX} service installed.$NORMAL"
  line
}

function vmagentConf {
  sudo tee -a <<EOF >/dev/null /etc/prometheus/prometheus.yml
  - job_name:       'validator'
    scrape_interval: 30s
    scrape_timeout: 30s
    metrics_path: /metrics/validator
    static_configs:
      - targets:
        - ${VALOPER}
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_address
      - source_labels: [__param_address]
        target_label: instance
      - target_label: __address__
        replacement: localhost:${EXPORTER_PORT}
  # specific wallet(s)
  - job_name:       'wallet'
    scrape_interval: 30s
    scrape_timeout: 30s
    metrics_path: /metrics/wallet
    static_configs:
      - targets:
        - ${WALLET}
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_address
      - source_labels: [__param_address]
        target_label: instance
      - target_label: __address__
        replacement: localhost:${EXPORTER_PORT}

  # all validators
  - job_name:       'validators'
    scrape_interval: 30s
    scrape_timeout: 30s
    metrics_path: /metrics/validators
    static_configs:
      - targets:
        - localhost:${EXPORTER_PORT}
EOF
sudo systemctl restart vmagent
}

function launch {
    setup "${1}" "${2}" "${3}" "${4}" "${5}" "${6}" "${7}" "${8}"
    install_tools
    install_go
    installSource
    binService
    vmagentConf

    line
    echo -e "$GREEN cosmos-exporter builded and configured.$NORMAL"
    line
    echo -e "$GREEN Now installed cosmos-exporter for your tcp://localhost:${NODE_PORT} !$NORMAL"
    line
    echo -e "$YELLOW Use$NORMAL$RED sudo systemctl start cosmos-exporter-${COSMOS_PREFIX}.service$NORMAL$YELLOW To start service$NORMAL"
    echo -e "$YELLOW Use$NORMAL$RED sudo journalctl -u cosmos-exporter-${COSMOS_PREFIX}.service -f$NORMAL$YELLOW To view service logs$NORMAL"
    line
    echo -e "$GREEN DONE$NORMAL"
    line
}

while getopts ":g:f:b:c:v:s:z:j:" o; do
  case "${o}" in
    g)
      g=${OPTARG}
      ;;
    f)
      f=${OPTARG}
      ;;
    b)
      b=${OPTARG}
      ;;
    c)
      c=${OPTARG}
      ;;
    v)
      v=${OPTARG}
      ;;
    s)
      s=${OPTARG}
      ;;
    z)
      z=${OPTARG}
      ;;
    j)
      j=${OPTARG}
      ;;
  esac
done
shift $((OPTIND-1))

launch "${g}" "${f}" "${b}" "${c}" "${v}" "${s}" "${z}" "${j}"
