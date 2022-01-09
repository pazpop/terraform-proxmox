<p align="center"><a href="#"><img src="./logo.png" alt="Packer logo"></a></p>
<h2 align="center">Packer code for build a golden image</h2>

# Table of Contents
* [Documentations](#documentations)
* [Todo](#todo)
* [Requirements](#requirements)
* [Build a CentOS 7 image](#build-a-centos-7-image)
* [Build a Ubuntu 20 image](#build-a-ubuntu-20-image)
* [Contributing](#contributing)

# Documentations
* [https://www.packer.io/docs/builders/proxmox](https://www.packer.io/docs/builders/proxmox)
* [https://pve.proxmox.com/wiki/Cloud-Init_Support](https://pve.proxmox.com/wiki/Cloud-Init_Support)
* [https://pykickstart.readthedocs.io/en/latest/kickstart-docs.html](https://pykickstart.readthedocs.io/en/latest/kickstart-docs.html)
* [https://docs.centos.org/en-US/centos/install-guide/Kickstart2/](https://docs.centos.org/en-US/centos/install-guide/Kickstart2/)
* [https://ubuntu.com/server/docs/install/autoinstall-reference](https://ubuntu.com/server/docs/install/autoinstall-reference)

# Todo
Presently, when you create a VM with a boot disk > 10Go, the sda doesn't increase automaticly. The growpart Cloundinit module doesn't work.
I should fix that with this module: https://cloudinit.readthedocs.io/en/latest/topics/modules.html#scripts-per-boot

The work around:
```sh
fdisk -l /dev/sda
parted /dev/sda
resizepart 2 100%
quit
pvresize /dev/sda2
lvresize --extents +100%FREE --resizefs /dev/mapper/centos_centos7--template-root
```

# Requirements
## Install packer (v1.6.6):
```sh
cat << EOF > /etc/apt/sources.list.d/hashicorp.list
deb https://apt.releases.hashicorp.com buster main
EOF
curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
apt update
apt install -y packer
```

## Create user
```sh
ssh root@proxmox-server
pveum user add terraform@pve --password <my-strong-password>
pveum aclmod / -user terraform@pve -role Administrator
useradd terraform && passwd terraform
```

# Build a CentOS 7 image
## Requirements
* To be connect on the proxmox server
* Download the last Centos 7 image:
```sh
curl --http1.1 -o /var/lib/vz/template/iso/CentOS-7-x86_64-DVD-2009.iso http://centos.mirror.iweb.ca/7.9.2009/isos/x86_64/CentOS-7-x86_64-DVD-2009.iso
```

## Build with Packer
* build image
```sh
packer build \
  -var pve_username="terraform@pve" \
  -var pve_password="<my-strong-password>" \
  -var pve_url="https://proxmox-server:8006/api2/json" \
  -var pve_node="proxmox-server" \
  centos-7.json
```

# Build a Ubuntu 20 image
## Requirements
* To be connect on the proxmox server
* Download the last image:
```sh
curl --http1.1 -o /var/lib/vz/template/iso/ubuntu-20.04.2-live-server-amd64.iso https://mirror.its.dal.ca/ubuntu-releases/20.04.2/ubuntu-20.04.2-live-server-amd64.iso
```

## Build with Packer
* build image
```sh
packer build \
  -var pve_username="terraform@pve" \
  -var pve_password="<my-strong-password>" \
  -var pve_url="https://proxmox-server:8006/api2/json" \
  -var pve_node="proxmox-server" \
  ubuntu-20.json
```

# Contributing
1. Create a issue
2. Fork the Project
3. Create your feature Branch (`git checkout -b feature/issue#1`)
4. Test your code
```sh
yum install pykickstart
ksvalidator ./centos7/ks.cfg
```
4. Commit your changes (`git commit -m 'Add some features'`)
5. Push to the branch (`git push origin feature/issue#1`)
6. Open a Pull request