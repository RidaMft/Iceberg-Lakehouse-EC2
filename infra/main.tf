# main.tf

##############################
# Récupération de l'AMI
##############################
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["137112412989"] # Amazon

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

##############################
# Récupération du VPC par défaut
##############################
data "aws_vpc" "default" {
  default = true
}

##############################
# Clé SSH pour accéder à l'EC2
##############################
resource "aws_key_pair" "default" {
  key_name   = var.key_name
  public_key = file("~/.ssh/${var.key_name}.pub")
}