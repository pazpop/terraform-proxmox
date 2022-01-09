variable "pve_api_url" {
  description = "Proxmox API endpoint"
  type        = string
  default     = "https://proxmox-server:8006/api2/json"
}

variable "pve_proxmox_ip" {
  description = "The IP address of the proxmox server"
  type        = string
  default     = "proxmox-server"
}

variable "pve_target_node" {
  description = "The proxmox node name"
  type        = string
  default     = "proxmox-server"
}

variable "pve_ressource_pool" {
  description = "The proxmox ressource pool name"
  type        = string
  default     = "pool0"
}

variable "pve_user" {
  description = "The user who have access to the Proxmox API (with Administrator privilege)"
  type        = string
  default     = "terraform@pve"
}

variable "pve_ssh_user" {
  description = "The user who have access to the Proxmox API (with Administrator privilege)"
  type        = string
  default     = "terraform"
}

variable "my_ssh_public_key" {
  description = "Your public RSA key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "number_of_vms" {
  description = "Number of VMs do you want to create"
  type        = number
  default     = 40
}

variable "vm_desc" {
  type    = string
  default = "VM test"
}
