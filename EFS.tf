resource "aws_efs_file_system" "efs-asg" {
  creation_token   = "ASG-EFS"
  encrypted        = true
  performance_mode = "generalPurpose"
  tags = {
    Name = "myASG"
  }
}
resource "aws_efs_mount_target" "mount" {
  file_system_id  = aws_efs_file_system.efs-asg.id
  subnet_id       = aws_subnet.pub_with_asg.id
  security_groups = [aws_security_group.for_efs.id]
}
