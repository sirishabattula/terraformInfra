#!/usr/bin/env bash
set -x
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo apt install software-properties-common -y 
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt-get install ansible -y



