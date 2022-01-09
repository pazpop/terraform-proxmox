# Prerequis
* Create a `terraform` user on your Proxmox server (if needed)
```sh
ssh root@proxmox-server
pveum user add terraform@pve --password my-strong-password
pveum aclmod / -user terraform@pve -role Administrator
useradd terraform && passwd terraform
# add the password in this file: secrets/terraform_password
```

* Create a pool (if needed)
```sh
pvesh create /pools --poolid pool0
```

* Build the VM template with Packer
* Create this directory on the proxmox server: `mkdir -p /var/lib/vz/snippets && chown -R terraform:terraform /var/lib/vz/snippets`
* If you execute the `terraform apply` from your PC, please add your public RSA key in the `/root/.ssh/authorized_keys` file on the proxmox server.

# Create x VMs
```sh
cd ~/
git clone
cd terraform-proxmox/3_vms-creation
git secret reveal
```
* `cd proxmox-server`
* Change the `number_of_vms` in the `variables.tf` file for have your number of VMs.
* Please verify if you Proxmox VE can hosts this number of VMs :) 

```sh
terraform init
terraform plan
terraform apply
```

# Destroy x VMs
```sh
cd terraform-proxmox/3_vms-creation
terraform destroy
```

# Contributing
1. Create a issue
2. Fork the Project
3. Create your feature Branch (`git checkout -b feature/issue#1`)
4. Valide your code (`terraform fmt && terraform validate`)
5. Commit your changes (`git commit -m 'Add some features'`)
6. Push to the branch (`git push origin feature/issue#1`)
7. Open a Pull request