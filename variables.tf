# This file defines the input variables for the VPC module.
# It includes the CIDR blocks for the VPC, public subnet, and private subnet,
# as well as the key name for EC2 instances.
# FILEPATH: /Users/chadthompsonsmith/DevOpsAlpha/terraform_all/my-terraform-vpc/variables.tf

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
}

variable "key_name" {
  description = "Key name for EC2 instances"
  type        = string
}
