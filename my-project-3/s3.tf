resource "aws_s3_bucket" "testbucket" {
  bucket = "${var.my_enviroment}-test-my-app-bucket-d-${random_string.rand.id}"

  tags = {
    Name = "${var.my_enviroment}-test-my-app-bucket-d"
  }
}

resource "random_string" "rand" {
  length = 6
  special = false
  upper = false
}

