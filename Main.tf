terraform {
  backend "s3" {
    bucket         = "terraform-state-by-uber"
    key            = "global/s3/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
resource "aws_kms_key" "s3key" {
  description             = "Key to encrypt bucket obj"
  deletion_window_in_days = 10
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
