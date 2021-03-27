resource "aws_launch_template" "LTforASG" {
  depends_on = [
    aws_ami_from_instance.uberami
  ]

  name = "LT-ASG"
  
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = "t2.micro"
  key_name                             = "uber"

  vpc_security_group_ids = [aws_security_group.pub_SG.id]
  image_id = aws_ami_from_instance.uberami.id
  network_interfaces {
    associate_public_ip_address = true
    subnet_id                   = aws_subnet.pub_with_asg.id
    delete_on_termination       = true
}
}
