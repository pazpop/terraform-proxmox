// Doc: https://github.com/ondrejsika/terraform-provider-proxmox/blob/master/docs/provider.md
provider "proxmox" {
  pm_api_url      = var.pve_api_url
  pm_user         = var.pve_user
  pm_password     = file("../secrets/terraform_password")
  pm_tls_insecure = true
  pm_parallel     = 4
}