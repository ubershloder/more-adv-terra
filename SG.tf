resource "aws_security_group" "pub_SG" {
  
  name        = "for ssh/http/mysql"
  description = "allow 22/80/3306 ports"
  
  vpc_id      = aws_vpc.terra.id
  
  ingress {
    description = "for orchestator"
    from_port   = var.orchestrator_port
    to_port     = var.orchestrator_port
    protocol    = "UDP"
    cidr_blocks = [aws_vpc.terra.cidr_block]
  }
#  dynamic "ingress" {
#    for_each = ["22", "80", "443", "2377", "3306"]
#    content {
#      from_port   = ingress.key
#      to_port     = ingress.key
#      cidr_blocks = [var.all_cidr]
#      protocol    = "TCP"
#    }
#  }
  ingress {
    description = "for orchestator"
    from_port   = var.orchestrator_port
    to_port     = var.orchestrator_port
    protocol    = "TCP"
    cidr_blocks = [aws_vpc.terra.cidr_block]
  }
  ingress {
    description = "for ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = [var.all_cidr]
  }
  ingress {
    description = "for http"
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = [var.all_cidr]
  }
  ingress {
    description = "for db"
    from_port   = 3306
    to_port     = 3306
    protocol    = "TCP"
    cidr_blocks = [var.all_cidr]
  }
  ingress {
    description = "for db"
    from_port   = 3306
    to_port     = 3306
    protocol    = "UDP"
    cidr_blocks = [var.all_cidr]
  }
  egress {
    description = "for db"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_cidr]
  }
  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "TCP"
    cidr_blocks = [aws_vpc.terra.cidr_block]
  }
  egress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "TCP"
    cidr_blocks = [aws_vpc.terra.cidr_block]
  }
  tags = {
    Name = "for instance"
  }
}
resource "aws_security_group" "DB_SG" {
  name        = "for database"
  description = "allow 22/80/3306 ports"
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
    from_port   = 2049
    to_port     = 2049
    protocol    = "TCP"
    cidr_blocks = [aws_vpc.terra.cidr_block]
  }
}
