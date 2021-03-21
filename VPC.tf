
resource "aws_vpc" "terra" {
  cidr_block           = "192.168.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_classiclink   = false
  tags = {
    Name = "for ec2 behind ASG"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.terra.id
  tags = {
    Name = "IG for vpc"
  }
}

resource "aws_subnet" "pub_with_asg" {
  availability_zone       = "eu-central-1a"
  vpc_id                  = aws_vpc.terra.id
  cidr_block              = "192.168.0.0/28"
  map_public_ip_on_launch = true
  tags = {
    Name = "public subnet"
  }
}

resource "aws_subnet" "pub_with_asg_forALB" {
  availability_zone       = "eu-central-1c"
  vpc_id                  = aws_vpc.terra.id
  cidr_block              = "192.168.3.0/28"
  map_public_ip_on_launch = true
  tags = {
    Name = "public subnet"
  }
}
resource "aws_subnet" "private_sub_DB" {
  availability_zone       = "eu-central-1c"
  vpc_id                  = aws_vpc.terra.id
  cidr_block              = "192.168.1.0/28"
  map_public_ip_on_launch = false #because its private_sub
  tags = {
    Name = "private subnet"
  }
}

resource "aws_subnet" "private_sub_db" {
  availability_zone       = "eu-central-1a"
  vpc_id                  = aws_vpc.terra.id
  cidr_block              = "192.168.2.0/28"
  map_public_ip_on_launch = false #because its private_sub
  tags = {
    Name = "private subnet"
  }
}

resource "aws_route_table" "r" {
  vpc_id = aws_vpc.terra.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}
resource "aws_route_table_association" "rt-to-sub" {
  subnet_id      = aws_subnet.pub_with_asg.id
  route_table_id = aws_route_table.r.id
}

resource "aws_db_subnet_group" "forRDS" {
  name       = "rds-sub-grp"
  subnet_ids = [aws_subnet.private_sub_db.id, aws_subnet.private_sub_DB.id]

  tags = {
    Name = "My RDS subnet group"
  }
}
