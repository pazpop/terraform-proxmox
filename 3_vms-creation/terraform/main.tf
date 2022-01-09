// Set variables for the template file
data "template_file" "pve_userdata" {
  count    = var.number_of_vms
  template = file("../templates/pve_userdata.cfg")

  vars = {
    hostname           = "my-vm-${count.index}"
    domain             = "domain.tld"
    ssh_authorized_key = file(var.my_ssh_public_key)
  }
}

// Create a local copy of the template with correct variables
resource "local_file" "pve_userdata_file" {
  count    = var.number_of_vms
  content  = data.template_file.pve_userdata[count.index].rendered
  filename = "../templates/pve_userdata_${count.index}.cfg"
}

// Transfer the cloud-config file to the Proxmox Host
resource "null_resource" "cloud_init_config_files" {
  count = var.number_of_vms
  connection {
    type     = "ssh"
    user     = var.pve_ssh_user
    password = file("../secrets/terraform_password")
    host     = var.pve_proxmox_ip
  }

  provisioner "file" {
    source      = local_file.pve_userdata_file[count.index].filename
    destination = "/var/lib/vz/snippets/pve_userdata_${count.index}.yml"
  }
}

// Create the VM
resource "proxmox_vm_qemu" "create-vm" {
  count = var.number_of_vms
  depends_on = [
    null_resource.cloud_init_config_files,
  ]

  name        = "my-vm-${count.index}"
  desc        = var.vm_desc
  target_node = var.pve_target_node
  pool        = var.pve_ressource_pool
  onboot      = false

  // Clone from centos-cloudinit template
  clone      = "centos-7-template"
  full_clone = false
  os_type    = "cloud-init"
  qemu_os    = "l26"
  agent      = 1

  // Cloud-init provisioning
  cicustom = "user=local:snippets/pve_userdata_${count.index}.yml"

  // Memory paramters
  memory  = "1024"
  balloon = 0

  // CPU paramters
  cores   = "2"
  sockets = "1"
  vcpus   = "2"
  cpu     = "kvm64"

  // boot disk paramters
  scsihw   = "virtio-scsi-single"
  boot     = "c"
  bootdisk = "scsi0"

  // disk paramters
  disk {
    size    = "10G"
    type    = "scsi"
    storage = "local-lvm"
  }

  // network paramters
  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  // Ignore changes to the network
  // https://github.com/Telmate/terraform-provider-proxmox/issues/112
  lifecycle {
    ignore_changes = [
      network
    ]
  }
}