#!/usr/bin/env bash
set -e

# update
sudo apt-get update -y

# install nginx
sudo apt-get install -y nginx

# create nginx upstream config (simple)
cat <<'EOF' | sudo tee /etc/nginx/sites-available/sportgather
upstream backend {
    server 192.168.56.11:8080;
}

server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_connect_timeout 5s;
        proxy_read_timeout 10s;
    }
}
EOF

sudo ln -sf /etc/nginx/sites-available/sportgather /etc/nginx/sites-enabled/sportgather
sudo rm -f /etc/nginx/sites-enabled/default
sudo systemctl restart nginx

# Install node_exporter for monitoring (so Prometheus can scrape)
NODE_VER="1.6.1"
wget -q https://github.com/prometheus/node_exporter/releases/download/v${NODE_VER}/node_exporter-${NODE_VER}.linux-amd64.tar.gz -O /tmp/node_exporter.tar.gz
sudo tar -xzf /tmp/node_exporter.tar.gz -C /opt
sudo ln -sf /opt/node_exporter-${NODE_VER}.linux-amd64/node_exporter /usr/local/bin/node_exporter

cat <<'EOF' | sudo tee /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
After=network.target

[Service]
Type=simple
User=root
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=default.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now node_exporter
