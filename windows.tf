locals {
  windows_tags = merge({ Name : "windows-server" }, var.tags, local.tags)
}

resource "aws_key_pair" "windows" {
  key_name   = "windows-server"
  public_key = file("${path.module}/keys/windows-server.pub")
  tags       = local.windows_tags
}

resource "aws_security_group" "windows" {
  name_prefix = "windows-server-"
  description = "windows-server"
  vpc_id      = var.vpc_id
  tags        = local.windows_tags

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "windows" {
  ami                         = data.aws_ami.ami["windows"].id
  instance_type               = "t3a.medium"
  associate_public_ip_address = true
  disable_api_termination     = false
  user_data                   = file("${path.module}/user_data/windows.txt")
  key_name                    = aws_key_pair.windows.key_name
  security_groups             = [aws_security_group.windows.name]
  tags                        = local.windows_tags
  volume_tags                 = local.windows_tags

  lifecycle {
    create_before_destroy = "true"
  }
}
