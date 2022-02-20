locals {
  build_server_tags = merge({ Name : "build-server" }, var.tags, local.tags)
}

resource "aws_iam_role" "build" {
  name_prefix = "build-server-"

  tags = merge(local.build_server_tags, {
    git_file = "build-server.tf"
    git_org  = "managedkaos"
  })

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "build" {
  role       = aws_iam_role.build.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "build" {
  name_prefix = "build-server-"
  role        = aws_iam_role.build.name

  tags = merge(local.build_server_tags, {
    git_file = "build-server.tf"
    git_org  = "managedkaos"
    git_repo = "jenkins-development-environment"
  })
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
  ami                         = data.aws_ami.ami["amazon"].id
  instance_type               = "t3a.nano"
  associate_public_ip_address = true
  disable_api_termination     = false
  user_data                   = file("${path.module}/user_data/build-server.txt")
  key_name                    = aws_key_pair.key["amazon"].key_name
  security_groups             = [aws_security_group.build.name]
  volume_tags                 = local.build_server_tags
  iam_instance_profile        = aws_iam_instance_profile.build.name

  tags = merge(local.build_server_tags, {
    git_file = "build-server.tf"
    git_org  = "managedkaos"
    git_repo = "jenkins-development-environment"
  })

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
  value = aws_instance.build.public_dns
}

output "build_private_dns" {
  value = aws_instance.build.private_dns
}

output "build_instance_id" {
  value = aws_instance.build.id
}
