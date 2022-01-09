terraform {
  // Terraform version
  required_version = ">= 0.14"

  // Remote states
  backend "gcs" {
    bucket      = "google-tf-states"
    prefix      = "my-project/proxmox"
    credentials = "../secrets/keyfile.json"
  }

  // Terraform provider for Proxmox VE
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.6.7"
    }
  }
}