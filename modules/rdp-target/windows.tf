# Get latest Windows Server 2016 AMI
# data "aws_ami" "windows-2022" {
#   most_recent = true
#   owners      = ["amazon"]
#   filter {
#     name   = "name"
#     values = ["Windows_Server-2022-English-Full-Base*"]
#   }
# }

data "aws_ami" "windows-2022" {
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

resource "aws_instance" "windows" {
  ami                    = data.aws_ami.windows-2022.id //"ami-0b204ba02c86d0218"
  instance_type          = "t3.micro"
  key_name               = var.rdp_aws_key_pair_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.cluster.id]
  get_password_data      = true

  tags = {
    Name  = "${var.friendly_name_prefix}-windows"
  }
}

resource "local_file" "windows_password" {
  content  = rsadecrypt(aws_instance.windows.password_data, file(var.rdp_private_key_path))
  filename = "${path.root}/generated/windows_password"
}