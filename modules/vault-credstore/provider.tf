terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
    }
    boundary = {
      source  = "hashicorp/boundary"
    }
  }
}
provider "boundary" {
  addr                   = var.boundary_endpoint
  auth_method_id         = var.auth_method_id
  auth_method_login_name = var.auth_admin_login_name
  auth_method_password   = var.auth_admin_password
}

provider "vault" {
  address = var.vault_addr
  token   = var.vault_token
}