locals {
  jenkins_tags = merge({ Name : "jenkins-server" }, var.tags, local.tags)
}

resource "aws_key_pair" "jenkins" {
  key_name   = "jenkins-server"
  public_key = file("${path.module}/keys/jenkins-server.pub")
  tags       = local.jenkins_tags
}

resource "aws_security_group" "jenkins" {
  name_prefix = "jenkins-server-"
  description = "jenkins"
  vpc_id      = var.vpc_id
  tags        = local.jenkins_tags

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_instance" "jenkins" {
  ami                         = data.aws_ami.ami["ubuntu"].id
  instance_type               = "t3a.medium"
  associate_public_ip_address = true
  disable_api_termination     = false
  user_data                   = file("${path.module}/user_data/jenkins.txt")
  key_name                    = aws_key_pair.jenkins.id
  security_groups             = [aws_security_group.jenkins.name]
  tags                        = local.jenkins_tags
  volume_tags                 = local.jenkins_tags

  lifecycle {
    create_before_destroy = "true"
  }
}
