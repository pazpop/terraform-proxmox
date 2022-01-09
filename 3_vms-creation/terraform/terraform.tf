terraform {
  // Terraform version
  required_version = ">= 0.13"

  // Remote states
  backend "gcs" {
    bucket      = "google-tf-states"
    prefix      = "loadtest/iweb-proxmox-20"
    credentials = "../secrets/gcp/keyfile.json"
  }

  // Terraform provider for Proxmox VE
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.6.7"
    }
  }
}