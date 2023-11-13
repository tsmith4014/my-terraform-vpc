# This file defines the outputs for the VPC module. It exports the IDs of the VPC, public subnet, and private subnet.

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
