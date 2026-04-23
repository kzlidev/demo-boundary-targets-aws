#variable "deployment_id" {
#  type = string
#}
#variable "owner" {
#  type = string
#}
#variable "vault_credstore_id" {
#  type = string
#}
#
#variable "infra_aws" {
#  type = object({
#    vpc_cidr_block                   = string
#    vpc_id                           = string
#    public_subnets                   = list(string)
#    private_subnets                  = list(string)
#    aws_keypair_key_name             = string
#    controller_internal_dns          = string
#    bastion_ip                       = string
#    vault_ip                         = string
#    bastion_security_group_id        = string
#    vault_security_group_id          = string
#    worker_ingress_security_group_id = string
#    worker_egress_security_group_id  = string
#    boundary_cluster_url             = string
#    worker_instance_profile          = string
#    session_storage_role_arn         = string
#  })
#}
#
#variable "boundary_resources" {
#  type = object({
#    org_id              = string
#    project_id          = string
#    static_credstore_id = string
#  })
#}

variable "region" {
  type = string
  default = "ap-southeast-1"
}

variable "friendly_name_prefix" {
  description = "This prefix will be included in the name of most resources."
}

variable "boundary_project_id" {
  type        = string
  description = "Boundary Project ID"
}

variable "boundary_org_id" {
  type        = string
  description = "Boundary Organization ID"
}

variable "vpc_id" {
  type        = string
  description = "VPC to deploy resource into"
}

variable "allow_rdp_3389_security_groups" {
  type        = list(string)
  description = "List of CIDR blocks to allow RDP port 3389 ingress"
}

variable "allow_rdp_3389_cidrs" {
  type        = list(string)
  description = "List of security group ids to allow RDP port 3389 ingress"
}

variable "rdp_aws_key_pair_name" {
  type        = string
  description = "RDP key"
}

variable "rdp_private_key_path" {}

variable "subnet_id" {
  description = "Subnet ID to deploy resource into"
  type        = string
}

variable "allowed_admin_principal_ids" {
  type        = list(string)
  description = "List of allowed admin principal IDs for the target"
}

variable "allowed_analyst_principal_ids" {
  type        = list(string)
  description = "List of allowed analyst principal IDs for the target"
}

variable "boundary_endpoint" {}

variable "auth_method_id" {}

variable "auth_admin_login_name" {}

variable "auth_admin_password" {}

variable "ami_owner" {}

variable "ami_name" {}
