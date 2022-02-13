data "aws_ami" "ami" {
  for_each    = var.ami
  most_recent = true
  owners      = each.value["owners"]

  filter {
    name   = "name"
    values = each.value["name"]
  }

  filter {
    name   = "virtualization-type"
    values = each.value["virtualization_type"]
  }

}

# output "ami" {
#   value = data.aws_ami.ami
# }
