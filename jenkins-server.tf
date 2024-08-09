locals {
  jenkins_tags = merge({ Name : "jenkins-server" }, var.tags, local.tags)
}

resource "aws_iam_role" "jenkins" {
  name_prefix = "jenkins-server-"

  tags = merge(var.tags, local.tags, {
    git_file = "jenkins-server.tf"
    git_org  = "managedkaos"
    git_repo = "jenkins-development-environment"
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

resource "aws_iam_role_policy_attachment" "jenkins" {
  role       = aws_iam_role.jenkins.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "jenkins" {
  name_prefix = "jenkins-server-"
  role        = aws_iam_role.jenkins.name

  tags = merge(local.jenkins_tags, {
    git_file = "jenkins-server.tf"
    git_org  = "managedkaos"
    git_repo = "jenkins-development-environment"
  })
}

resource "aws_security_group" "jenkins" {
  name_prefix = "jenkins-server-"
  description = "jenkins"
  vpc_id      = var.vpc_id

  tags = merge(local.jenkins_tags, {
    git_file = "jenkins-server.tf"
    git_org  = "managedkaos"
    git_repo = "jenkins-development-environment"
  })

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
  ami                         = coalesce("ami-0637e7dc7fcc9a2d9", data.aws_ami.ami["ubuntu"].id)
  instance_type               = "t3a.medium"
  associate_public_ip_address = true
  disable_api_termination     = false
  user_data                   = file("${path.module}/user_data/jenkins_v2.txt")
  key_name                    = aws_key_pair.key["ubuntu"].key_name
  security_groups             = [aws_security_group.jenkins.name]
  volume_tags                 = local.jenkins_tags
  iam_instance_profile        = aws_iam_instance_profile.jenkins.name

  tags = merge(local.jenkins_tags, {
    git_file = "jenkins-server.tf"
    git_org  = "managedkaos"
    git_repo = "jenkins-development-environment"
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eip" "jenkins" {
  vpc = true
  tags = merge(local.jenkins_tags, {
    git_file = "jenkins-server.tf"
    git_org  = "managedkaos"
    git_repo = "jenkins-development-environment"
  })
}

resource "aws_eip_association" "jenkins" {
  instance_id   = aws_instance.jenkins.id
  allocation_id = aws_eip.jenkins.id
}

output "jenkins_public_dns" {
  value = aws_eip.jenkins.public_dns
}

output "jenkins_instance_id" {
  value = aws_instance.jenkins.id
}
