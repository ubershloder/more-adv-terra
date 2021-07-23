resource "aws_security_group" "pub_SG" {

  name        = "for EC2"
  description = "allow needed ports"

  vpc_id = aws_vpc.terra.id

  dynamic "ingress" {
    for_each = ["22", "80", "443", "3306"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [var.all_cidr]
    }
  }
  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "TCP"
    cidr_blocks = [aws_vpc.terra.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [var.all_cidr]
  }
  tags = {
    Name = "for instance"
  }
}
resource "aws_security_group" "DB_SG" {
  name        = "for database"
  description = "DB port"
  vpc_id      = aws_vpc.terra.id
  ingress {
    description = "db out"
    from_port   = 3306
    to_port     = 3306
    protocol    = "TCP"
    cidr_blocks = [aws_vpc.terra.cidr_block]
  }
  egress {
    description = "db out"
    from_port   = 3306
    to_port     = 3306
    protocol    = "UDP"
    cidr_blocks = [aws_vpc.terra.cidr_block]
  }
}
resource "aws_security_group" "for_efs" {
  name        = "for EFS"
  description = "to allow connection of EFS to EC2 and ASG in future"
  vpc_id      = aws_vpc.terra.id
  ingress {
    description = "EFS out"
    from_port   = 2049
    to_port     = 2049
    protocol    = "TCP"
    cidr_blocks = [aws_vpc.terra.cidr_block]
  }
  egress {
    description = "EFS out"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [aws_vpc.terra.cidr_block]
  }
}
