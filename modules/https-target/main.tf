data "aws_ami" "ubuntu" {
  filter {
    name   = "name"
    values = [var.ami_name]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
  most_recent = true
  owners      = [var.ami_owner]
}

resource "aws_instance" "hashicat" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.cluster.id]
  iam_instance_profile   = aws_iam_instance_profile.boundary_https_ec2.name
  key_name               = var.bastion_ssh_aws_key_pair_name

  tags = {
    Name = "${var.friendly_name_prefix}-web-instance"
  }

  user_data = <<-EOT
#!/bin/bash
sudo apt -y update
sudo apt -y install apache2
sudo systemctl start apache2
sudo chown -R ubuntu:ubuntu /var/www/html

cat << EOM > /var/www/html/index.html
<html>
  <head><title>Meow!</title></head>
  <body>
  <div style="width:800px;margin: 0 auto">

  <!-- BEGIN -->
  <center><img src="http://${var.placeholder}/${var.width}/${var.height}"></img></center>
  <center><h2>Hello World!</h2></center>
  Welcome to ${var.friendly_name_prefix}'s app. Hello from Boundary Demo.
  <!-- END -->

  </div>
  </body>
</html>
EOM

sudo a2enmod ssl

cat << EOM > /etc/ssl/certs/hashicats.crt
${file(var.tls_cert_path)}
EOM

cat << EOM > /etc/ssl/private/hashicats.key
${file(var.tls_private_key_path)}
EOM

cat << EOM > /etc/apache2/sites-available/hashicats.conf
<VirtualHost *:443>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html

    SSLEngine on
    SSLCertificateKeyFile /etc/ssl/private/hashicats.key
    SSLCertificateFile /etc/ssl/certs/hashicats.crt

    ErrorLog $${APACHE_LOG_DIR}/error.log
    CustomLog $${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOM

sudo a2ensite hashicats.conf
sudo systemctl restart apache2
  EOT
}

# resource "tls_private_key" "hashicat" {
#   algorithm = "ED25519"
# }
#
# locals {
#   private_key_filename = "${var.prefix}-ssh-key.pem"
# }
#
# resource "aws_key_pair" "hashicat" {
#   key_name   = local.private_key_filename
#   public_key = tls_private_key.hashicat.public_key_openssh
# }
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_instance_profile" "boundary_https_ec2" {
  name = "${var.friendly_name_prefix}-boundary-https-instance-profile"
  path = "/"
  role = aws_iam_role.boundary_ec2.name
}

resource "aws_iam_role_policy_attachment" "aws_ssm" {
  role       = aws_iam_role.boundary_ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role" "boundary_ec2" {
  name = "${var.friendly_name_prefix}-boundary-https-instance-role"
  path = "/"

  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  tags = merge({ "Name" = "${var.friendly_name_prefix}-boundary-https-instance-role" })
}
