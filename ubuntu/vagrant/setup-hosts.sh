#!/bin/bash
set -e
IFNAME=$1
ADDRESS="$(ip -4 addr show $IFNAME | grep "inet" | head -1 |awk '{print $2}' | cut -d/ -f1)"
sed -e "s/^.*${HOSTNAME}.*/${ADDRESS} ${HOSTNAME} ${HOSTNAME}.local/" -i /etc/hosts

# remove ubuntu-bionic entry
sed -e '/^.*ubuntu-bionic.*/d' -i /etc/hosts

# Update /etc/hosts about other hosts
cat > /etc/hosts <<EOF
172.16.5.11  master-1
172.16.5.21  worker-1
172.16.5.23  worker-2
172.16.5.24  worker-3
172.16.5.25  worker-4
EOF

if ! grep -q "vm.swappiness" /etc/sysctl.conf; then
  sysctl -w vm.swappiness=0
fi

[ ! -d "/home/vagrant/.ssh" ] && mkdir -p /home/vagrant/.ssh
cp /vagrant/id_rsa* /home/vagrant/.ssh/
chmod 600 .ssh/id_rsa
chown -R vagrant:vagrant /home/vagrant/.ssh
cat /vagrant/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys


apt-get update && apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
		git \
		gnupg2 \
        software-properties-common \
		tmux \
		vim 