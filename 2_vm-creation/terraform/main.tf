// Set variables for the template file
data "template_file" "pve_userdata" {
  template = file("../templates/pve_userdata.cfg")

  vars = {
    hostname           = var.vm_hostname
    domain             = var.vm_domain
    ssh_authorized_key = file(var.my_ssh_public_key)
    vm_name_server_1   = var.dns_server_1
  }
}

// Create a local copy of the template with correct variables
resource "local_file" "pve_userdata_file" {
  content  = data.template_file.pve_userdata.rendered
  filename = "../templates/pve_userdata_${var.vm_hostname}.cfg"
}

// Transfer the cloud-config file to the Proxmox Host
resource "null_resource" "cloud_init_config_files" {
  connection {
    type     = "ssh"
    user     = var.pve_ssh_user
    password = file("../secrets/terraform_password")
    host     = var.pve_proxmox_ip
  }

  provisioner "file" {
    source      = local_file.pve_userdata_file.filename
    destination = "/var/lib/vz/snippets/pve_userdata_${var.vm_hostname}.yml"
  }
}

// Create the VM
resource "proxmox_vm_qemu" "vm" {
  depends_on = [
    null_resource.cloud_init_config_files,
  ]

  name        = var.vm_hostname
  desc        = var.vm_desc
  target_node = var.pve_target_node
  pool        = var.pve_ressource_pool
  onboot      = true

  // Clone from centos-cloudinit template
  clone   = "centos-7-template"
  os_type = "cloud-init"
  qemu_os = "l26"
  agent   = 1

  // Cloud init options
  cicustom  = "user=local:snippets/pve_userdata_${var.vm_hostname}.yml"
  ipconfig0 = "ip=${var.vm_ip},gw=${var.default_gw}"

  // Memory paramters
  memory  = "16384"
  balloon = 0

  // CPU paramters
  cores   = "4"
  sockets = "1"
  vcpus   = "0"
  cpu     = "host"

  // boot disk paramters
  scsihw   = "virtio-scsi-single"
  boot     = "c"
  bootdisk = "scsi0"

  // disk paramters
  disk {
    size    = "50G"
    type    = "scsi"
    storage = "local-lvm"
  }

  // network paramters
  network {
    model  = "virtio"
    bridge = "vmbr0"
    #tag = 101 #Vlan
  }

  // Ignore changes to the network
  // https://github.com/Telmate/terraform-provider-proxmox/issues/112
  lifecycle {
    ignore_changes = [
      network
    ]
  }
}