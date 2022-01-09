data "terraform_remote_state" "my-project" {
  backend = "gcs"

  config = {
    bucket      = "google-tf-states"
    prefix      = "my-project/proxmox"
    credentials = "../secrets/keyfile.json"
  }
}