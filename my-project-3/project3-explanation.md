Project-3: Terraform + EC2 + S3 + DynamoDB (Default VPC Project)
🔥 Overview

Is project me hum Terraform use karke AWS ke kuch important resources create kar rahe hain:

EC2 Instance (Ubuntu 22.04)

Security Group (SSH + HTTP + HTTPS)

Key Pair (SSH access ke liye)

S3 Bucket (unique random suffix ke saath)

DynamoDB Table

User Data script (Apache install)

Outputs (Public IP & ARN)

Ye project Shubham style + prod-style follow karta hai—with clean folders, separate files, tfvars, and proper variables.

📐 Architecture Diagram (Text)
                ┌─────────────────────────┐
                │  AWS Default VPC        │
                │  (Internet Enabled)     │
                └──────────┬──────────────┘
                           │
                   ┌───────▼────────┐
                   │ Security Group  │
                   │ SSH/HTTP/HTTPS  │
                   └───────┬────────┘
                           │
                   ┌───────▼────────┐
                   │ EC2 Instance    │
                   │ (User Data + Apache)
                   └─────────────────┘

            ┌────────────────┐        ┌────────────────────┐
            │ S3 Bucket      │        │ DynamoDB Table      │
            └────────────────┘        └────────────────────┘

📁 Folder Structure
my-project-3/
├── main.tf
├── ec2.tf
├── s3.tf
├── dynamodb.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── script.sh
├── terra-key
└── terra-key.pub

🚀 STEP-1: Configure AWS Credentials
vim ~/.aws/credentials


Add:

[default]
aws_access_key_id = YOUR_KEY
aws_secret_access_key = YOUR_SECRET

🚀 STEP-2: Create project folder
mkdir -p ~/terraform/my-project-3
cd ~/terraform/my-project-3

🚀 STEP-3: All Terraform Files
main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.65.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

👉 Explanation

AWS provider version fix kiya for stability.

Region variable se pick hota hai.

ec2.tf
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
  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.project3_sg.id
  ]

  user_data = file("${path.module}/script.sh")

  tags = {
    Name = "project3-ec2"
  }
}

👉 Explanation

Default VPC use karke public IP guaranteed.

Latest Ubuntu AMI auto pick hota hai.

SG me SSH, HTTP, HTTPS allow hai.

EC2 boot hote hi Apache install ho jata hai.

s3.tf
resource "aws_s3_bucket" "testbucket" {
  bucket = "${var.my_enviroment}-test-my-app-bucket-d-${random_string.rand.id}"

  tags = {
    Name = "${var.my_enviroment}-test-my-app-bucket-d"
  }
}

resource "random_string" "rand" {
  length  = 6
  special = false
  upper   = false
}

👉 Explanation

S3 bucket naam globally unique hota hai → random string add kiya.

dynamodb.tf
resource "aws_dynamodb_table" "my_app_table" {
    name = "${var.my_enviroment}-test-my-app-table-d"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "id"

    attribute {
        name = "id"
        type = "S"
    }
}

variables.tf
variable "aws_region" {
  description = "AWS region where resources will be deployed"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Instance type"
  default     = "t2.micro"
}

variable "my_enviroment" {
  description = "Deployment environment"
  default     = "dev"
}

terraform.tfvars
aws_region    = "us-east-1"
instance_type = "t2.micro"
my_enviroment = "dev"

script.sh
#!/bin/bash
apt update -y
apt install apache2 -y
systemctl start apache2
systemctl enable apache2

echo "Project 3 successfully deployed!" > /var/www/html/index.html

outputs.tf
output "public_ip" {
  value = aws_instance.project3_ec2.public_ip
}

output "instance_arn" {
  value = aws_instance.project3_ec2.arn
}

🚀 STEP-4: Terraform Commands
Initialize
terraform init

Validate
terraform validate

Plan
terraform plan

Apply
terraform apply -auto-approve

🌍 STEP-5: Website Test

Browser me open karo:

http://PUBLIC_IP


Ya:

https://PUBLIC_IP

🧹 STEP-6: Cleanup
terraform destroy -auto-approve

⭐⭐⭐ GitHub Upload Steps (Add these below README) ⭐⭐⭐
1️⃣ Check your repo folder
cd ~/terraform


Repo me yeh hona chahiye:

my-project-1/
my-project-2/
my-project-3/
.git
.gitignore
README.md

2️⃣ Important: Ignore keys (security)

.gitignore me add karo:

terra-key
terra-key.pub

3️⃣ Add changes
git add .

4️⃣ Commit
git commit -m "Added Project-3 with prod-style Terraform setup"

5️⃣ Push to GitHub
git push origin main


Agar first time push:

git push -u origin main

🎉 DONE!

Project-3 successfully GitHub par upload ho jayega.

⭐⭐⭐ ADD THIS SECTION TO YOUR PROJECT-3 README.md ⭐⭐⭐

(Production-style Backend Explanation + Code)

## 🔥 Terraform Remote Backend (S3 + DynamoDB) – Production Setup

In Project-3, we upgraded the Terraform workflow from local state to a fully production-grade remote backend using:

S3 bucket (stores Terraform state file)

DynamoDB table (handles state locking)

Versioning + Encryption for safety

Automatic state migration

This is the same architecture used in real DevOps teams for safe, scalable infrastructure deployments.

### 1️⃣ S3 Bucket (for storing terraform.tfstate)

We created the following S3 bucket manually:

project3-backend-state


Bucket settings:

Public access → Blocked

Versioning → Enabled

Encryption → SSE-S3 (default)

Bucket Key → Disabled

This ensures that Terraform state:

✔ Is stored safely
✔ Has version history
✔ Is protected from accidental deletion
✔ Supports recovery and rollbacks

### 2️⃣ DynamoDB Table (for state locking)

We created a DynamoDB table to prevent simultaneous terraform apply operations.

Table details:

Table name: terraform-lock
Partition key: LockID (String)
Billing mode: On-demand


This ensures:

✔ Only one Terraform operation runs at a time
✔ No corruption in infrastructure
✔ Safe state locking like production workloads

### 3️⃣ Backend Block Added in main.tf

At the top of main.tf, we added:

terraform {
  backend "s3" {
    bucket         = "project3-backend-state"
    key            = "project3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}


This tells Terraform to use:

S3 → for storing state

DynamoDB → for locking

Encryption → enabled

### 4️⃣ Migrating State to Backend

We migrated the existing local state using:

terraform init


Terraform asked:

Do you want to copy existing state to the new backend?


We typed:

yes


And the migration completed successfully.

### 5️⃣ Verification Steps

After migration:

✔ Local folder:

terraform.tfstate removed
terraform.tfstate.backup kept

✔ S3 bucket:

project3/terraform.tfstate appeared

✔ DynamoDB:

Lock created during plan/apply, removed after completion

✔ CLI Output:

Messages like:

Acquiring state lock...
Releasing state lock...
Successfully configured the backend "s3"!


confirmed that backend was working correctly.

### 6️⃣ Why Remote Backend is Important?

Production environments always use remote backends because:

BENEFIT	WHY IT MATTERS
Team collaboration	Multiple engineers can work safely
State safety	S3 versioning prevents corruption
Automatic locking	DynamoDB prevents apply conflicts
Recovery	State can be restored anytime
Consistency	All machines share the same state

Tumhara Project-3 ab 100% production-grade Terraform project ban chuka hai.

⭐⭐⭐ END OF README ADDITION ⭐⭐⭐

Copy paste this whole block into project3-explanation.md OR README.md inside my-project-3.
