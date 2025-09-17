resource "aws_security_group" "cluster" {

  name        = "${var.friendly_name_prefix}-private-http"
  description = "Allow SSH and HTTP/S private inbound"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.friendly_name_prefix}-private-http"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "rule_https_443" {
  count                    = length(var.allow_https_80_443_security_groups)
  security_group_id        = aws_security_group.cluster.id
  protocol                 = "tcp"
  from_port                = 443
  to_port                  = 443
  type                     = "ingress"
  source_security_group_id = var.allow_https_80_443_security_groups[count.index]
}

resource "aws_security_group_rule" "rule_http_80" {
  count                    = length(var.allow_https_80_443_security_groups)
  security_group_id        = aws_security_group.cluster.id
  protocol                 = "tcp"
  from_port                = 80
  to_port                  = 80
  type                     = "ingress"
  source_security_group_id = var.allow_https_80_443_security_groups[count.index]
}

resource "aws_security_group_rule" "rule_ssh_22" {
  count                    = length(var.allow_ssh_22_security_groups)
  security_group_id        = aws_security_group.cluster.id
  protocol                 = "tcp"
  from_port                = 22
  to_port                  = 22
  type                     = "ingress"
  source_security_group_id = var.allow_https_80_443_security_groups[count.index]
}

resource "aws_security_group_rule" "rule_ssh_22_cidr" {
  security_group_id = aws_security_group.cluster.id
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = var.allow_ssh_22_cidrs
}

resource "aws_security_group_rule" "allow_all_egress" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  security_group_id = aws_security_group.cluster.id
  cidr_blocks       = ["0.0.0.0/0"]
}
#module "private-https-inbound" {
#  source = "terraform-aws-modules/security-group/aws"
#
#  name        = "${var.prefix}-private-http"
#  description = "Allow HTTP/S private inbound"
#  vpc_id      = var.vpc_id
#
#  ingress_with_source_security_group_id = [
#    {
#      rule                     = "http-80-tcp"
#      source_security_group_id = var.egress_worker_security_group_id
#    },
#    {
#      rule                     = "http-80-tcp"
#      source_security_group_id = var.infra_aws.bastion_security_group_id
#    },
#    {
#      rule                     = "https-443-tcp"
#      source_security_group_id = var.egress_worker_security_group_id
#    },
#    {
#      rule                     = "https-443-tcp"
#      source_security_group_id = var.infra_aws.bastion_security_group_id
#    },
#    {
#      rule                     = "ssh-tcp"
#      source_security_group_id = var.egress_worker_security_group_id
#    },
#    {
#      rule                     = "ssh-tcp"
#      source_security_group_id = var.ingress_worker_security_group_id
#    },
#    {
#      rule                     = "ssh-tcp"
#      source_security_group_id = var.infra_aws.bastion_security_group_id
#    },
#  ]
#
#  egress_rules = ["all-all"]
#  egress_cidr_blocks = ["0.0.0.0/0"]
#}
