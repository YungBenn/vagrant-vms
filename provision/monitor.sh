#!/usr/bin/env bash
set -e

sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

# install docker
if ! command -v docker >/dev/null 2>&1; then
  curl -fsSL https://get.docker.com -o get-docker.sh
  sudo sh get-docker.sh
  sudo usermod -aG docker vagrant
fi

# install docker-compose (v2 plugin)
sudo apt-get install -y docker-compose-plugin

# create docker-compose with prometheus and grafana
mkdir -p /home/vagrant/monitor
cat > /home/vagrant/monitor/docker-compose.yml <<'YML'
version: "3.7"
services:
  prometheus:
    image: prom/prometheus:v2.51.0
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml:ro
    ports:
      - "9090:9090"

  grafana:
    image: grafana/grafana:10.0.0
    ports:
      - "3000:3000"
    volumes:
      - grafana-storage:/var/lib/grafana

volumes:
  grafana-storage:
YML

# prometheus config: scrape node_exporter from the 3 VMs
cat > /home/vagrant/monitor/prometheus.yml <<'PY'
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'node_exporter'
    static_configs:
      - targets: ['192.168.56.10:9100', '192.168.56.11:9100', '192.168.56.12:9100']

  - job_name: 'app'
    static_configs:
      - targets: ['192.168.56.11:8080']
PY

sudo chown -R vagrant:vagrant /home/vagrant/monitor

# run docker compose
cd /home/vagrant/monitor
sudo docker compose up -d
