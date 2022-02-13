locals {
  build_server_tags = merge({ Name : "build-server" }, var.tags, local.tags)
}

resource "aws_security_group" "build" {
  name_prefix = "build-server-"
  description = "build"
  vpc_id      = var.vpc_id
  tags = merge(local.build_server_tags, {
    git_file = "build-server.tf"
    git_org  = "managedkaos"
    git_repo = "jenkins-development-environment"
  })

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "6"
    security_groups = [aws_security_group.jenkins.id]
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "build" {
  ami                         = data.aws_ami.ami["ubuntu"].id
  instance_type               = "t3a.medium"
  associate_public_ip_address = true
  disable_api_termination     = false
  user_data                   = file("${path.module}/user_data/build-server.txt")
  key_name                    = aws_key_pair.key["amazon"].key_name
  security_groups             = [aws_security_group.build.name]
  volume_tags                 = local.build_server_tags
  tags                        = local.build_server_tags

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_eip" "build" {
  vpc = true
  tags = merge(local.build_server_tags, {
    git_file = "build-server.tf"
    git_org  = "managedkaos"
    git_repo = "jenkins-development-environment"
  })
}

resource "aws_eip_association" "build" {
  instance_id   = aws_instance.build.id
  allocation_id = aws_eip.build.id
}

output "build_public_dns" {
  value = aws_instance.jenkins.public_dns
}

output "build_instance_id" {
  value = aws_instance.build.id
}
