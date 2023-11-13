// This file contains the variables used in the Terraform configuration for creating a VPC with public and private subnets.
// FILEPATH: /Users/chadthompsonsmith/DevOpsAlpha/terraform_all/my-terraform-vpc/terraform.tfvars
#terraform.tfvars
vpc_cidr            = "10.0.0.0/16"
public_subnet_cidr  = "10.0.1.0/24"
private_subnet_cidr = "10.0.2.0/24"
key_name            = "cpdevopsew-eu-west-2"
