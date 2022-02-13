terraform {
  required_version = "~> 1.0.5"

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    random = {
      source = "hashicorp/random"
    }
    template = {
      source = "hashicorp/template"
    }
    null = {
      source = "hashicorp/null"
    }
  }

  backend "s3" {
    key    = "ENTER_THE_S3_KEY_HERE/terraform.tfstate"
    bucket = "ENTER_THE_S3_BUCKET_HERE"
    region = "ENTER_THE_S3_REGION_HERE"
  }
}

provider "aws" {
  default_tags {
    tags = {
      Terraform = true
    }
  }
}
