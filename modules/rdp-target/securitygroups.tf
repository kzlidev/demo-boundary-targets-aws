resource "aws_security_group" "cluster" {

  name        = "${var.friendly_name_prefix}-private-rdp"
  description = "Allow RDP private inbound"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.friendly_name_prefix}-private-http"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "rule_https_443" {
  count                    = length(var.allow_rdp_3389_security_groups)
  security_group_id        = aws_security_group.cluster.id
  protocol                 = "tcp"
  from_port                = 3389
  to_port                  = 3389
  type                     = "ingress"
  source_security_group_id = var.allow_rdp_3389_security_groups[count.index]
}

resource "aws_security_group_rule" "rule_ssh_22_cidr" {
  security_group_id = aws_security_group.cluster.id
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = var.allow_rdp_3389_cidrs
}

resource "aws_security_group_rule" "allow_all_egress" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  security_group_id = aws_security_group.cluster.id
  cidr_blocks       = ["0.0.0.0/0"]
}