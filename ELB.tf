resource "aws_elb" "ELB" {
  name            = "ELB2"
  security_groups = [aws_security_group.pub_SG.id]
  subnets         = [aws_subnet.pub_with_asg.id, aws_subnet.pub_with_asg_forALB.id]
  listener {
  instance_port = 80
  instance_protocol = "http"
  lb_port = 80 
  lb_protocol = "http"
}
  tags = {
    Name = "testing"
 }
}
