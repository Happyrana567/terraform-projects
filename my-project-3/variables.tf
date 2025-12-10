variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Instance type for EC2"
  default     = "t2.micro"
}

variable "my_enviroment" {
  description = "Deployment environment"
  default     = "dev"
}
