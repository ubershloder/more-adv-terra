resource "aws_kms_key" "s3key" {
description = "Key to encrypt bucket obj"
deletion_window_in_days = 10
}

resource "aws_s3_bucket" "terraform_state_files" {
  bucket = "terraform-state-by-uber"
  lifecycle {
    prevent_destroy = true
  }
  versioning {
    enabled = true
    }
      server_side_encryption_configuration {
      rule {
        apply_server_side_encryption_by_default {
          kms_master_key_id = aws_kms_key.s3key.id
          sse_algorithm = "aws:kms"
        }
      }
    }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
