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

wget https://github.com/caddyserver/caddy/releases/download/v2.4.6/caddy_2.4.6_linux_amd64.tar.gz
tar -vxf caddy_2.4.6_linux_amd64.tar.gz
sudo mv caddy /usr/bin/
rm -f caddy_2.4.6_linux_amd64.tar.gz

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
sudo systemctl daemon-reload
sudo systemctl start caddy
sudo systemctl enable caddy
