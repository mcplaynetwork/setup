#!/bin/bash

echo "############ Setup timezone ############"

sudo timedatectl set-timezone Asia/Tokyo

echo "############ Setup docker ############"

sudo apt-get update
sudo apt-get install -y \
ca-certificates \
curl \
gnupg

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
"$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "############ Install docker ############"

sudo apt-get update
sudo apt-get install -y \
docker-ce \
docker-ce-cli \
containerd.io \
docker-buildx-plugin \
docker-compose-plugin

echo "############ apt-get upgrade ############"

sudo apt-get upgrade -y

echo "############ Portainer agent ############"

sudo docker volume create portainer_data
sudo docker run -d \
    --name portainer \
    -p 8000:8000 \
    -p 9443:9443 \
    --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data \
    portainer/portainer-ce:latest
