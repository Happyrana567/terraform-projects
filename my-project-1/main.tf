#############################################
# 1. VPC
#############################################

resource "aws_vpc" "project_vpc" {
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "project-1-vpc"
  }
}

#############################################
# 2. Internet Gateway
#############################################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.project_vpc.id

  tags = {
    Name = "project-1-igw"
  }
}

#############################################
# 3. Public Subnet
#############################################

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.project_vpc.id
  cidr_block              = "10.0.0.0/28"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "project-1-public-subnet"
  }
}

#############################################
# 4. Route Table + Route
#############################################

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.project_vpc.id

  tags = {
    Name = "project-1-public-rt"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

#############################################
# 5. Security Group — allow SSH/HTTP/HTTPS
#############################################

resource "aws_security_group" "web_sg" {
  name        = "project-1-web-sg"
  description = "Allow ports 22, 80, 443"
  vpc_id      = aws_vpc.project_vpc.id

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

  tags = {
    Name = "project-1-web-sg"
  }
}

#############################################
# 6. EC2 Instance
#############################################

resource "aws_instance" "web_server" {
  ami           = "ami-011899242bb902164" # Ubuntu 20.04 LTS (us-east-1)
  instance_type = "t2.micro"

  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = aws_key_pair.my_key_pair.key_name
  user_data              = file("${path.module}/nginx_setup.sh")

  tags = {
    Name = "project-1-ec2"
  }
}


#############################################
# 7. key pair (login)
#############################################

resource "aws_key_pair" "my_key_pair" {
  key_name   = "terrakey-01"
  public_key = file("${path.module}/keys/terrakey-01.pub")
}


#############################################
# 8. Output — Public IP
#############################################

output "web_server_ip" {
  value = aws_instance.web_server.public_ip
}

#############################################
# 9. NAT Gateway (Commented — future use)
#############################################

# resource "aws_eip" "nat_eip" {
#   vpc = true
# }

# resource "aws_nat_gateway" "nat_gw" {
#   allocation_id = aws_eip.nat_eip.id
#   subnet_id     = aws_subnet.public_subnet.id
#
#   tags = {
#     Name = "project-1-nat-gateway"
#   }
# }

#############################################
# 10. SSL / HTTPS Future Reference (Commented)
#############################################

# resource "aws_acm_certificate" "ssl_cert" {
#   domain_name       = "example.com"
#   validation_method = "DNS"
# }


