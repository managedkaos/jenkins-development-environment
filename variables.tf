variable "name" {
  type        = string
  default     = "jenkins-development-environment"
  description = "The name to assign to resources in this module"
}

variable "environment" {
  type        = string
  default     = "production"
  description = "The environment to assign to resource in this module"
}

variable "vpc_id" {
  type        = string
  default     = "vpc-099756a148825974e"
  description = "Just another default VPC"
}

variable "tags" {
  type        = map(any)
  default     = {}
  description = "Tags to asscociate to taggable resources in this module"
}

variable "ami" {
  type = map(any)
  default = {
    "ubuntu" = {
      "owners"              = ["099720109477"]
      "name"                = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
      "virtualization_type" = ["hvm"]
    }
    # "amazon" = {
    #   "owners"              = ["amazon"]
    #   "name"                = ["amzn2-ami-hvm-*-x86_64-ebs"]
    #   "virtualization_type" = ["hvm"]
    # }
    # "windows" = {
    #   "owners"              = ["801119661308"]
    #   "name"                = ["Windows_Server-2022-English-Full-Base-2022.*"]
    #   "virtualization_type" = ["hvm"]
    # }
  }
}
