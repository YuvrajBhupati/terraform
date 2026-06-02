provider "aws" {
  region = "us-east-1"
}

# 🔴 CRITICAL: Public S3 bucket (major risk)
resource "aws_s3_bucket" "bad_bucket" {
  bucket = "demo-insecure-bucket-12345"
  acl    = "public-read"   # ❌ public access
}

resource "aws_s3_bucket_public_access_block" "bad_block" {
  bucket = aws_s3_bucket.bad_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# 🔴 HIGH: Open security group
resource "aws_security_group" "bad_sg" {
  name = "bad-sg"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]   # ❌ open to world
  }
}

# 🔴 HIGH: Unencrypted DB
resource "aws_db_instance" "bad_db" {
  allocated_storage   = 20
  engine              = "mysql"
  instance_class      = "db.t3.micro"
  username           = "admin"
  password           = "password123"

  storage_encrypted   = false   # ❌ no encryption
  skip_final_snapshot = true
}

# 🔴 CRITICAL: Hardcoded secret
variable "aws_secret" {
  default = "AKIAIOSFODNN7EXAMPLE123"  # ❌ secret detection
}
