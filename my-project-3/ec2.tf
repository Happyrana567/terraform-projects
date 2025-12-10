# -------------------- DEFAULT VPC --------------------
data "aws_vpc" "default" {
  default = true
}
# -------------------- AMI DATA SOURCE --------------------
data "aws_ami" "ubuntu_latest" {
  owners      = ["099720109477"]   # Canonical
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}
# -------------------- KEY PAIR --------------------
resource "aws_key_pair" "project3_key" {
  key_name   = "project3-key"
  public_key = file("${path.module}/terra-key.pub")
}

# -------------------- SECURITY GROUP --------------------
resource "aws_security_group" "project3_sg" {
  name        = "project3-sg"
  description = "Allow SSH, HTTP, HTTPS"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# -------------------- EC2 INSTANCE --------------------
resource "aws_instance" "project3_ec2" {
  ami                         = data.aws_ami.ubuntu_latest.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.project3_key.key_name
  associate_public_ip_address = true   # <-- PUBLIC IP GUARANTEED

  vpc_security_group_ids = [
    aws_security_group.project3_sg.id
  ]

  user_data = file("${path.module}/script.sh")

  tags = {
    Name = "project3-ec2"
  }
}
