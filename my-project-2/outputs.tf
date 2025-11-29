#########################################
# Project 2 - Outputs
#########################################

# VPC ID
output "vpc_id" {
  value       = aws_vpc.main_vpc.id
  description = "VPC ID created by Terraform"
}

# Public Subnets IDs
output "public_subnet_ids" {
  value       = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  description = "IDs of public subnets"
}

# Security Group ID
output "security_group_id" {
  value       = aws_security_group.web_sg.id
  description = "Security Group ID for both EC2 instances"
}

# EC2 Instance 1 Public IP
output "web_server_1_public_ip" {
  value       = aws_instance.web_server_1.public_ip
  description = "Public IP of EC2 instance 1"
}

# EC2 Instance 1 Public DNS
output "web_server_1_public_dns" {
  value       = aws_instance.web_server_1.public_dns
  description = "Public DNS of EC2 instance 1"
}

# EC2 Instance 2 Public IP
output "web_server_2_public_ip" {
  value       = aws_instance.web_server_2.public_ip
  description = "Public IP of EC2 instance 2"
}

# EC2 Instance 2 Public DNS
output "web_server_2_public_dns" {
  value       = aws_instance.web_server_2.public_dns
  description = "Public DNS of EC2 instance 2"
}

