# Custom VPC Creation in AWS using Terraform

This guide provides detailed instructions for creating a custom Virtual Private Cloud (VPC) in AWS using Terraform. The steps include setting up the project, creating a VPC, subnets, internet gateway, route table, security groups, and launching resources.

## Prerequisites

- Terraform installed on your system.
- AWS Account and AWS CLI configured with credentials.
- Basic understanding of AWS and Terraform.

## Step 1: Initialize Terraform Project

1. **Create a New Directory**: Make a new directory for your Terraform project.

   ```shell
   mkdir my-terraform-vpc
   cd my-terraform-vpc
   ```

2. **Initialize Terraform**:

   ```shell
   terraform init
   ```

## Step 2: Create a VPC

1. **Terraform Configuration File**: Create a file named `main.tf`.
2. **Define AWS Provider**:

   ```hcl
   provider "aws" {
     region = "eu-west-2"
   }
   ```

3. **Define VPC Resource**:

   ```hcl
   resource "aws_vpc" "custom_vpc" {
     cidr_block = var.vpc_cidr
   }
   ```

## Step 3: Create Subnets

1. **Public Subnet**:

   ```hcl
   resource "aws_subnet" "public_subnet" {
     vpc_id     = aws_vpc.custom_vpc.id
     cidr_block = var.public_subnet_cidr
   }
   ```

2. **Private Subnet**:

   ```hcl
   resource "aws_subnet" "private_subnet" {
     vpc_id     = aws_vpc.custom_vpc.id
     cidr_block = var.private_subnet_cidr
   }
   ```

## Step 4: Create an Internet Gateway

1. **Internet Gateway**:

   ```hcl
   resource "aws_internet_gateway" "gw" {
     vpc_id = aws_vpc.custom_vpc.id
   }
   ```

## Step 5: Create a Route Table

1. **Route Table for Public Subnet**:

   ```hcl
   resource "aws_route_table" "public_route_table" {
     vpc_id = aws_vpc.custom_vpc.id

     route {
       cidr_block = "0.0.0.0/0"
       gateway_id = aws_internet_gateway.gw.id
     }
   }
   ```

2. **Associate Public Subnet**:

   ```hcl
   resource "aws_route_table_association" "public" {
     subnet_id      = aws_subnet.public_subnet.id
     route_table_id = aws_route_table.public_route_table.id
   }
   ```

## Step 6: Create Security Groups

1. **Security Group for EC2 Instances**:

<!-- # Create a security group for the EC2 instance -->

```hcl
resource "aws_security_group" "ec2_sg" {
vpc_id = aws_vpc.custom_vpc.id

 <!-- # Allow inbound HTTP traffic -->

ingress {
description = "HTTP"
from_port = 80
to_port = 80
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}

 <!-- # Allow inbound HTTPS traffic -->

ingress {
description = "HTTPS"
from_port = 443
to_port = 443
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}

 <!-- # Allow inbound SSH traffic from the user's IP address -->

ingress {
description = "SSH"
from_port = 22
to_port = 22
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"] # cidr_blocks = ["your_ip_address/32"] // Replace with your IP address if you want to restrict SSH access to just your IP address
}

 <!-- # Allow all outbound traffic -->

egress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}
}

```

## Step 7: Launch Resources

1. **EC2 Instance in Public Subnet**:

   ```hcl
   resource "aws_instance" "public_instance" {
     ami           = "ami-id"  # Replace with a valid AMI ID
     instance_type = "t2.micro"
     subnet_id     = aws_subnet.public_subnet.id
     key_name      = var.key_name

     security_groups = [aws_security_group.ec2_sg.name]
   }
   ```

## Additional Files and Setup

This section details the creation of additional Terraform configuration files necessary for managing variables, outputs, and default values. These files contribute to the modular and maintainable structure of your Terraform project.

## `variables.tf`: Variable Definitions

1. **Create `variables.tf` File**:

   - This file will declare the variables used in your Terraform configurations.

   ```shell
   touch variables.tf
   ```

2. **Define Variables**:

   - Open `variables.tf` and define the following variables:

   ```hcl
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
   ```

## `outputs.tf`: Output Definitions

1. **Create `outputs.tf` File**:

   - This file will define the outputs to display after Terraform execution.

   ```shell
   touch outputs.tf
   ```

2. **Define Outputs**:

   - Open `outputs.tf` and define outputs for VPC ID, Subnet IDs, etc.:

   ```hcl
   output "vpc_id" {
     description = "The ID of the VPC"
     value       = aws_vpc.custom_vpc.id
   }

   output "public_subnet_id" {
     description = "The ID of the public subnet"
     value       = aws_subnet.public_subnet.id
   }

   output "private_subnet_id" {
     description = "The ID of the private subnet"
     value       = aws_subnet.private_subnet.id
   }
   ```

## `terraform.tfvars`: Default Variable Values

1. **Create `terraform.tfvars` File** (Optional):

   - This file is optional and is used for setting default values for your variables.

   ```shell
   touch terraform.tfvars
   ```

2. **Set Default Values**:

   - Open `terraform.tfvars` and set default values for variables.

   ```hcl
   vpc_cidr            = "10.0.0.0/16"
   public_subnet_cidr  = "10.0.1.0/24"
   private_subnet_cidr = "10.0.2.0/24"
   key_name            = "cpdevopsew-eu-west-2"
   ```

   - These values can be modified as per your project requirements.

## Execution

- **Plan**: Run `terraform plan` to see the changes that will be applied.
- **Apply**: Execute `terraform apply` to create the resources in AWS.
- **Destroy**: Use `terraform destroy` when you want to remove the resources.

## Conclusion

This guide provides a comprehensive approach to setting up a custom VPC in AWS using Terraform. Ensure to replace placeholders like `ami-id` with actual values. Always review Terraform plans before applying them.
