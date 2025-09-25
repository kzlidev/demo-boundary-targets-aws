terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "boundary" {
  addr                   = var.boundary_endpoint
  auth_method_login_name = var.auth_admin_login_name
  auth_method_password   = var.auth_admin_password
}

provider "aws" {
  region = var.region
}