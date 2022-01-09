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

variable "vm_hostname" {
  description = "The VM hostname"
  type        = string
  default     = "vm-name"
}

variable "vm_desc" {
  description = "The VM description"
  type        = string
  default     = "vm-description"
}

variable "vm_domain" {
  description = "The domain name of the VM"
  type        = string
  default     = "domain.tld"
}

variable "vm_ip" {
  description = "The VM IP"
  type        = string
  default     = "192.168.0.200/24"
}

variable "default_gw" {
  description = "The default gateway of the VM"
  type        = string
  default     = "192.168.0.1"
}

variable "dns_server_1" {
  description = "The DNS server of the VM"
  type        = string
  default     = "192.168.0.1"
}
