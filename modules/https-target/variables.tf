variable "friendly_name_prefix" {
  description = "This prefix will be included in the name of most resources."
}

variable "region" {
  description = "The region where the resources are created."
  default     = "ap-southeast-1"
}
#
#variable "address_space" {
#  description = "The address space that is used by the virtual network. You can supply more than one address space. Changing this forces a new resource to be created."
#  default     = "10.0.0.0/16"
#}
#
#variable "subnet_prefix" {
#  description = "The address prefix to use for the subnet."
#  default     = "10.0.10.0/24"
#}
#
variable "instance_type" {
  description = "Specifies the AWS instance type."
  default     = "t2.micro"
}

variable "subnet_id" {
  description = "Subnet ID to deploy resource into"
  type        = string
}
#
#variable "admin_username" {
#  description = "Administrator user name for mysql"
#  default     = "hashicorp"
#}

variable "vpc_id" {
  type        = string
  description = "VPC to deploy resource into"
}

variable "allow_https_80_443_security_groups" {
  type        = list(string)
  description = "List of security group ids to allow HTTP port 80 and 443 ingress"
}

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

#variable "infra_aws" {
#  type = object({
#    vpc_cidr_block                   = string
#    vpc_id                           = string
#    public_subnets = list(string)
#    private_subnets = list(string)
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

variable "boundary_org_id" {
  type        = string
  description = "Boundary Organization ID"
}

variable "boundary_project_id" {
  type        = string
  description = "Boundary Project ID"
}

variable "boundary_credstore_id" {
  type        = string
  description = "Credential store ID"
}

variable "tls_cert_path" {
  type = string
}

variable "tls_private_key_path" {
  type = string
}

variable "height" {
  default     = "500"
  description = "Image height in pixels."
}

variable "width" {
  default     = "600"
  description = "Image width in pixels."
}

variable "placeholder" {
  default     = "placebear.com"
  description = "Image-as-a-service URL. Some other fun ones to try are fillmurray.com, placecage.com, placebeard.it, loremflickr.com, baconmockup.com, placeimg.com, placebear.com, placeskull.com, stevensegallery.com, placedog.net"
}

variable "boundary_endpoint" {

}

variable "auth_admin_login_name" {}

variable "auth_admin_password" {}

variable "allowed_principal_ids" {
  type        = list(string)
  description = "List of allowed principal IDs for the target"
}