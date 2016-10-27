#!/bin/bash

# Docker
apt-get update
apt-get install -y apt-transport-https ca-certificates
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | tee /etc/apt/sources.list.d/docker.list
apt-get update
apt-cache policy docker-engine
apt-get install -y docker-engine
service docker start
groupadd docker
usermod -aG docker $USER
curl -L -o etcd-v2.3.7-linux-amd64.tar.gz https://github.com/coreos/etcd/releases/download/v2.3.7/etcd-v2.3.7-linux-amd64.tar.gz
tar xzvf etcd-v2.3.7-linux-amd64.tar.gz
mv etcd-v2.3.7-linux-amd64/etcd /usr/local/bin/etcd
mv etcd-v2.3.7-linux-amd64/etcdctl /usr/local/bin/etcdctl
mkdir -p /var/etcd/
service etcd start
curl -L -o /opt/bin/setup-network-environment https://github.com/kelseyhightower/setup-network-environment/releases/download/v1.0.0/setup-network-environment
chmod +x /opt/bin/setup-network-environment
/opt/bin/setup-network-environment
curl -L -o /opt/bin/flannel-0.5.2-linux-amd64.tar.gz https://github.com/coreos/flannel/releases/download/v0.5.2/flannel-0.5.2-linux-amd64.tar.gz
tar -C /opt/bin -xzvf /opt/bin/flannel-0.5.2-linux-amd64.tar.gz
/mv /opt/bin/flannel-0.5.2/flanneld /opt/bin/flanneld
rm -rf /opt/bin/flannel-0.5.2
rm -rf /opt/bin/flannel-0.5.2-linux-amd64.tar.gz
service flannel start

