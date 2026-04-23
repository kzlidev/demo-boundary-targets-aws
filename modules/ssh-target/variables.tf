variable "friendly_name_prefix" {}

variable "boundary_org_id" {}

variable "boundary_project_id" {}

variable "subnet_id" {}

variable "vpc_id" {}

variable "allowed_principal_ids" {}

variable "boundary_endpoint" {}

variable "auth_admin_login_name" {}

variable "auth_admin_password" {}

variable "auth_method_id" {}

variable "ami_owner" {}

variable "ami_name" {}

variable "region" {}

variable "bastion_ip" {}

variable "bastion_ssh_key_path" {}

variable "vault_credstore_id" {}

variable "allow_ssh_22_security_groups" {
  type        = list(string)
  description = "List of security group ids to allow SSH port 22 ingress"
}

variable "allow_ssh_22_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks to allow SSH port 22 ingress"
}

variable "bastion_ssh_aws_key_pair_name" {
  type        = string
  description = "Bastion SSH key"
}

# variable "session_recording_bucket" {}
#
# variable "session_recording_bucket_role" {}

variable "session_recording_bucket_id" {}

variable "vault_addr" {}

variable "vault_token" {}

variable "ami_image_id" {}
# variable "deployment_id" {
#   type = string
# }
#
# variable "owner" {
#   type = string
# }
# variable "vault_credstore_id" {
#   type = string
# }
#
# variable "bastion_ip" {
#   type = string
# }
#
#
# variable "infra_aws" {
#   type = object({
#     vpc_cidr_block                   = string
#     vpc_id                           = string
#     public_subnets                   = list(string)
#     private_subnets                  = list(string)
#     aws_keypair_key_name             = string
#     controller_internal_dns          = string
#     bastion_ip                       = string
#     vault_ip                         = string
#     bastion_security_group_id        = string
#     vault_security_group_id          = string
#     worker_ingress_security_group_id = string
#     worker_egress_security_group_id  = string
#     boundary_cluster_url             = string
#     worker_instance_profile          = string
#     session_storage_role_arn         = string
#   })
# }
#
# variable "boundary_resources" {
#   type = object({
#     org_id                   = string
#     project_id               = string
#   })
# }
