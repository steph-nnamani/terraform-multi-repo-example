provider "aws" {
  region  = "us-east-1"
  profile = "terraform"
}

# Terraform Backend Infrastructure

resource "aws_s3_bucket" "terraform_state" {
  bucket = var.aws_s3_bucket.bucket
  tags   = var.aws_s3_bucket.tags
  lifecycle {
    prevent_destroy = false # Not in production
  }
}

# Enable versioning so we can see the history of our state files
resource "aws_s3_bucket_versioning" "enable" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Add a separate block for public access settings
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_dynamodb_table" "terraform_locks" {

  # provider      = aws.west
  name     = var.aws_dynamodb_table.name
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  billing_mode = "PAY_PER_REQUEST"
  tags         = var.aws_dynamodb_table.tags
}

