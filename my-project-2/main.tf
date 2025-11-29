#########################################
# Project 2 - Main Infrastructure File
#########################################

# -------------------- VPC --------------------
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-vpc"
    }
  )
}

# -------------------- Internet Gateway --------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-igw"
    }
  )
}

# -------------------- Public Subnet 1 --------------------
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-public-subnet-1"
    }
  )
}

# -------------------- Public Subnet 2 --------------------
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_subnet_2_cidr
  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-public-subnet-2"
    }
  )
}

# -------------------- Route Table --------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-public-rt"
    }
  )
}

# -------------------- Public Route --------------------
resource "aws_route" "public_internet_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# -------------------- RT Associations --------------------
resource "aws_route_table_association" "public_rt_assoc_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_assoc_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

# -------------------- Security Group --------------------
resource "aws_security_group" "web_sg" {
  name        = "${local.project_name}-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-sg"
    }
  )
}

# -------------------- Key Pair --------------------
resource "aws_key_pair" "project_key" {
  key_name   = var.key_name
  public_key = file("~/.ssh/${var.key_name}.pub")
}

# -------------------- EC2 Instance in Subnet 1 --------------------
resource "aws_instance" "web_server_1" {
  ami                    = "ami-0c7217cdde317cfec"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet_1.id
  key_name               = aws_key_pair.project_key.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = templatefile("${path.module}/userdata.tpl", {
    project_name = local.project_name
  })

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-ec2-1"
    }
  )
}

# -------------------- EC2 Instance in Subnet 2 --------------------
resource "aws_instance" "web_server_2" {
  ami                    = "ami-0c7217cdde317cfec"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet_2.id
  key_name               = aws_key_pair.project_key.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = templatefile("${path.module}/userdata.tpl", {
    project_name = local.project_name
  })

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-ec2-2"
    }
  )
}

###############################################
### CHARGEABLE RESOURCES (COMMENTED OUT)
###############################################

# resource "aws_nat_gateway" "nat" { ... }   # CHARGEABLE – DO NOT CREATE
# resource "aws_eip" "nat_eip" { ... }        # CHARGEABLE – DO NOT CREATE

