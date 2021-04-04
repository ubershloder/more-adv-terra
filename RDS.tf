#data "aws_secretsmanager_secret_version" "RDS_pass" {
# secret_id = data.aws_secretsmanager_secret.uber.id
#}
resource "aws_db_instance" "RDS" {

  allocated_storage     = 8
  max_allocated_storage = 10
  storage_type          = "gp2"

  engine         = "mysql"
  engine_version = "8.0.20"
  instance_class = "db.t2.micro"
  name     = "terraform"

  username = var.username
  password = var.password

  skip_final_snapshot     = true
  backup_retention_period = 0
  maintenance_window      = "Mon:00:00-Mon:03:00"

  db_subnet_group_name   = aws_db_subnet_group.forRDS.id
  availability_zone      = "eu-central-1c"
  vpc_security_group_ids = [aws_security_group.DB_SG.id]

  port = 3306
  tags = {
    Name = "DB instance "
  }
}
data "terraform_remote_state" "RDS" {
  backend = "s3"
 config = {
    bucket = "terraform-state-by-uber"
    key    = "global/s3/terraform.tfstate"
    region = "eu-central-1"
  }
}

