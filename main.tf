# main.tf
# Define the AWS provider and region
provider "aws" {
  region = "eu-west-2"
}

# Create a custom VPC with the specified CIDR block
resource "aws_vpc" "custom_vpc" {
  cidr_block = var.vpc_cidr
}

# Create a public subnet within the custom VPC
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true # Enable auto-assign public IP
}

# Create a private subnet within the custom VPC
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.custom_vpc.id
  cidr_block = var.private_subnet_cidr
}

# Create an internet gateway and attach it to the custom VPC
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.custom_vpc.id
}

# Create a public route table and add a default route to the internet gateway
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

# Associate the public subnet with the public route table
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Create a security group for the EC2 instance
resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.custom_vpc.id

  # Allow inbound HTTP traffic
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow inbound HTTPS traffic
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow inbound SSH traffic from the user's IP address
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # cidr_blocks = ["your_ip_address/32"] // Replace with your IP address if you want to restrict SSH access to just your IP address
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch a public EC2 instance in the public subnet
resource "aws_instance" "public_instance" {
  ami           = "ami-06d0baf788edae448" // Amazon Linux 2 AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  key_name      = var.key_name

  # Associate the security group with the instance
  security_groups = [aws_security_group.ec2_sg.id]
}
