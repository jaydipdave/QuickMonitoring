#!/bin/bash

CA_VER=v0.26.1
NODE_VER=0.14.0.linux-amd64

if [ ! -f ./cadvisor ]; then
  wget https://github.com/google/cadvisor/releases/download/$CA_VER/cadvisor
  chmod +x cadvisor
fi

if [ ! -f ./vault ]; then
  wget https://releases.hashicorp.com/vault/0.8.1/vault_0.8.1_linux_amd64.zip
  unzip vault_0.8.1_linux_amd64.zip
  chmod +x vault
fi

if [ ! -f ./node_exporter ]; then
  wget https://github.com/prometheus/node_exporter/releases/download/v0.14.0/node_exporter-$NODE_VER.tar.gz
  tar xzfv node_exporter-$NODE_VER.tar.gz
  mv node_exporter-$NODE_VER/node_exporter ./
  chmod +x node_exporter
  rm -rf node_exporter-$NODE_VER
fi

chmod +x entry-point.sh

docker build . -t agent

