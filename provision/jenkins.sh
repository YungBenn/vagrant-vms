#!/usr/bin/env bash

echo "[INFO] Updating packages..."
sudo apt-get update -y

echo "[INFO] Installing Java (required for Jenkins)..."
sudo apt-get install -y openjdk-11-jdk

echo "[INFO] Adding Jenkins repo key..."
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo "[INFO] Adding Jenkins apt repository..."
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null

echo "[INFO] Installing Jenkins..."
sudo apt-get update -y
sudo apt-get install -y jenkins

echo "[INFO] Enabling & starting Jenkins..."
sudo systemctl enable jenkins
sudo systemctl start jenkins

echo "[INFO] Jenkins installation complete!"
