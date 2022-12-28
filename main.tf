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
   bucket         = var.state_bucket_
   key            = "baseline"
   region         = "eu-west-2"
   encrypt        = true
   kms_key_id     = "alias/terraform-state-bucket-key"
   dynamodb_table = aws_dynamodb_table.terraform_state_lock_table.name
 }
}

resource "aws_kms_key" "terraform_state_bucket_encryption_key" {
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

resource "aws_kms_alias" "terraform_state_bucket_encryption_key_alias" {
  name          = "alias/terraform-state-bucket-key"
  target_key_id = aws_kms_key.terraform_state_bucket_encryption_key.key_id
}

# S3 State Bucket
resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket_prefix = "terraform-state"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_bucket_encryption_configuration" {
  bucket = aws_s3_bucket.terraform_state_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.terraform_state_bucket_encryption_key.arn
      sse_algorithm     = "aws:kms"
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
  name         = "TerraformStateLockTable"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}