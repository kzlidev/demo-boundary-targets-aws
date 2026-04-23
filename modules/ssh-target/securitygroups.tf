resource "aws_security_group" "cluster" {

  name        = "${var.friendly_name_prefix}-private-ssh"
  description = "Allow SSH private inbound"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.friendly_name_prefix}-private-ssh"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "rule_ssh_22" {
  count                    = length(var.allow_ssh_22_security_groups)
  security_group_id        = aws_security_group.cluster.id
  protocol                 = "tcp"
  from_port                = 22
  to_port                  = 22
  type                     = "ingress"
  source_security_group_id = var.allow_ssh_22_security_groups[count.index]
}

data "http" "current_ip" {
  url = "https://checkip.amazonaws.com"
}

resource "aws_security_group_rule" "rule_ssh_22_cidr" {
  security_group_id = aws_security_group.cluster.id
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  type              = "ingress"
  cidr_blocks = concat(
    var.allow_ssh_22_cidrs,
    ["${chomp(data.http.current_ip.response_body)}/32"]
  )
}