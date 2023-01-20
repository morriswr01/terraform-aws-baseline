terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.40"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

terraform {
  backend "s3" {
    bucket         = "terraform-state20230120191738107900000001"
    key            = "baseline"
    region         = "eu-west-2"
    encrypt        = true
    dynamodb_table = "TerraformStateLockTable"
  }
}

resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket_prefix = "terraform-state"
}

# Happy just using the AWS managed KMS key here for now but generally better to use a CMK
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_bucket_encryption_configuration" {
  bucket = aws_s3_bucket.terraform_state_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state_bucket_public_access_block" {
  bucket = aws_s3_bucket.terraform_state_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform_state_lock_table" {
  name         = "TerraformStateLock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}