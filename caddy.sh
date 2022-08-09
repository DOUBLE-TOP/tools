function app_name {
  if [ ! $app ]; then
  echo -e "Enter your app name"
  line
  read app
  fi
}

function api_port {
  if [ ! $api_port ]; then
  echo -e "Enter your api port"
  line
  read api_port
  fi
}

function grpc_port {
  if [ ! $grpc_port ]; then
  echo -e "Enter your grpc port"
  line
  read grpc_port
  fi
}

function logo {
  curl -s https://raw.githubusercontent.com/razumv/helpers/main/doubletop.sh | bash
}

function line {
  echo "-----------------------------------------------------------------------------"
}

logo
line
app_name
line
api_port
line
grpc_port

sudo tee -a <<EOF >/dev/null $HOME/Caddyfile
wss://ws-$app.postcapitalist.io {
 reverse_proxy localhost:$grpc_port
}

https://$app.postcapitalist.io {
 reverse_proxy localhost:$api_port
}
EOF

sudo apt update && sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https

curl -1sLf 'https://dl.cloudsmith.io/public/caddy/xcaddy/gpg.key' | sudo apt-key add -

curl -1sLf 'https://dl.cloudsmith.io/public/caddy/xcaddy/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-xcaddy.list

sudo apt update && sudo apt install xcaddy -y

xcaddy build --with github.com/caddy-dns/cloudflare

sudo mv caddy /usr/bin/

sudo tee <<EOF >/dev/null /etc/systemd/system/caddy.service
[Unit]
Description=Caddy
Documentation=https://caddyserver.com/docs/
After=network.target

[Service]
User=root
ExecStart=/usr/bin/caddy run --config /root/Caddyfile
ExecReload=/usr/bin/caddy reload --config /root/Caddyfile
TimeoutStopSec=5s
LimitNOFILE=1048576
LimitNPROC=512
PrivateTmp=true
ProtectSystem=full
AmbientCapabilities=CAP_NET_BIND_SERVICE

[Install]
WantedBy=multi-user.target
EOF

systemctl start caddy
systemctl enable caddy
