data "aws_ami" "an_image" {
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  most_recent = true
  owners      = ["099720109477"]
}

resource "tls_private_key" "ssh-ca" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}


resource "aws_instance" "linux" {
  ami                    = var.ami_image_id
  instance_type          = "t3.micro"
  key_name               = var.bastion_ssh_aws_key_pair_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.cluster.id]

  provisioner "file" {
    content     = tls_private_key.ssh-ca.public_key_openssh
    destination = "/tmp/ca.pub"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sh -c 'cat /tmp/ca.pub >> /etc/ssh/cas.pub'",
      "sudo systemctl restart ssh",
    ]
  }

  connection {
    bastion_host        = var.bastion_ip
    bastion_user        = "ubuntu"
    agent               = false
    bastion_private_key = file(var.bastion_ssh_key_path)

    host        = self.private_ip
    user        = "ubuntu"
    private_key = file(var.bastion_ssh_key_path)
  }

  tags = {
    Name = "${var.friendly_name_prefix}-linux-target"
  }
}
