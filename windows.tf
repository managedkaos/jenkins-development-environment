resource "aws_key_pair" "windows" {
  key_name   = "windows-server"
  public_key = file("${path.module}/keys/windows-server.pub")
  tags       = merge(var.tags, local.tags)
}

resource "aws_security_group" "windows" {
  name_prefix = "windows"
  description = "windows"
  vpc_id      = var.vpc_id
  tags        = merge(var.tags, local.tags)

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
  instance_type               = "t4g.large"
  associate_public_ip_address = true
  disable_api_termination     = true
  key_name                    = aws_key_pair.windows.key_name
  security_groups             = [aws_security_group.windows.name]
  tags                        = merge(var.tags, local.tags)
  volume_tags                 = merge(var.tags, local.tags)
}
