#!/usr/bin/env bash
set -e

sudo apt-get update -y
sudo apt-get install -y postgresql postgresql-contrib

# create user & db
sudo -u postgres psql -c "CREATE USER vagrant WITH PASSWORD 'vagrant' ;" || true
sudo -u postgres psql -c "ALTER USER vagrant WITH SUPERUSER ;" || true
sudo -u postgres psql -c "CREATE DATABASE sportgather_db OWNER vagrant ;" || true

# allow remote connections from private network
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/*/main/postgresql.conf
echo "host    all             all             192.168.56.0/24          md5" | sudo tee -a /etc/postgresql/*/main/pg_hba.conf
sudo systemctl restart postgresql

# node_exporter for metrics
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
