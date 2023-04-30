#!/bin/bash

function generate_password() {
    echo $(cat /dev/urandom | tr -dc a-zA-Z0-9 | head -c16)
}

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

echo "############ Generate docker project ############"

mkdir -p ~/docker

echo "############ Setup wings ############"

mkdir -p ~/docker/wings
cd ~/docker/wings

echo "############ Generate .env ############"

if [ -e .env ]; then
    cp .env .env.bak
    rm .env
fi

touch .env
MYSQL_PASSWORD=$(generate_password)
echo "MYSQL_PASSWORD=$MYSQL_PASSWORD" >> .env

echo "############ Create docker-compose.yml ############"

if [ -e docker-compose.yml ]; then
    cp docker-compose.yml docker-compose.yml.bak
    rm docker-compose.yml
fi

wget https://raw.githubusercontent.com/mcplaynetwork/setup/main/wings/docker-compose.yml

echo "############ Start wings ############"

sudo docker-compose up -d
