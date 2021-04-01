resource "aws_elb" "ELB" {
  name            = "ELB"
  security_groups = [aws_security_group.pub_SG.id]
  subnets         = [aws_subnet.pub_with_asg.id, aws_subnet.pub_with_asg_forALB.id]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  tags = {
    Name = "testing"
  }
}
resource "aws_lb_target_group" "TG" {
name = "TG-for-ASG" 
port = 80 
protocol = "HTTP"
vpc_id = aws_vpc.terra.id
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_elb.ELB.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
 target_group_arn = aws_lb_target_group.TG.id
  type = "forward"
}
}

resource "aws_lb_target_group" "asg" {
  name     = "terraform-asg-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.terra.id
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 60
    timeout             = 5
    healthy_threshold    = 5
    unhealthy_threshold = 3
  }
}
