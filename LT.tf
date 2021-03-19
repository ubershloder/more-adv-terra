resource "aws_launch_template" "LTforASG" {
  depends_on = [
    aws_ami_from_instance.uberami
  ]
 
  name = "LT-ASG"
  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 8
    }
  }
  
  credit_specification {
    cpu_credits = "standart"
  }
  
  instance_initiated_shutdown_behavior = "terminate"
  ebs_optimized                        = true
  instance_type                        = "t2.micro"
  key_name                             = "uber"
  monitoring {
  enabled = true  
}
  
  image_id = aws_ami_from_instance.uberami.id
  
  network_interfaces {
    associate_public_ip_address = true
    subnet_id = aws_subnet.pub_with_asg.id
  }
  
  placement {
    availability_zone = "eu-central-1a"
  }
}
