output "public_ip" {
  value = aws_instance.project3_ec2.public_ip
}

output "instance_arn" {
  value = aws_instance.project3_ec2.arn
}
