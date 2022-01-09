#!/bin/bash
set -e

# Init
sleep 10

# Upgrade
yum -y update
yum -y upgrade

# Install package
yum -y install \
    epel-release \
    kexec-tools \
    yum-utils \
    cloud-init \
    qemu-guest-agent \
    vim \
    htop \
    net-tools \
    curl \
    wget \
    telnet \
    unzip \
    rsync \
    jq \
    bind-utils \
    net-snmp \
    net-snmp-utils \
    device-mapper-persistent-data \
    lvm2 \
    ipmitool \
    git \
    ntp

# Install Docker and docker-compose
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum -y install \
    docker-ce docker-ce-cli \
    containerd.io
curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
systemctl enable docker
systemctl start docker

# Config the admusr user
usermod -aG docker admusr
su - -c "mkdir -p /home/admusr/.ssh" admusr
su - -c "ssh-keygen -q -t rsa -f ~/.ssh/id_rsa -N ''" admusr
cat << EOF > /home/admusr/.ssh/authorized_keys
My ssh-rsa Keys
EOF
chown -R admusr:admusr /home/admusr
su - -c "chmod 600 .ssh/authorized_keys" admusr
echo "admusr        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/admusr

# Configure ntp
timedatectl set-timezone America/Toronto
cat << EOF > /etc/ntp.conf
# Configured by Packer
server 0.ca.pool.ntp.org iburst
server 1.ca.pool.ntp.org iburst
driftfile /var/lib/ntp/drift
restrict default nomodify notrap nopeer noquery
restrict 127.0.0.1 
restrict ::1
disable monitor
EOF
systemctl stop ntpd
ntpdate -s 0.ca.pool.ntp.org
systemctl start ntpd
systemctl enable ntpd

# Clean up
yum -y clean all
rm -rf /var/cache/yum /var/lib/yum/yumdb/*
rm -f /root/*ks*
unset HISTFILE; rm -rf /home/*/.*history /root/.*history
passwd -d root
passwd -l root

exit 0