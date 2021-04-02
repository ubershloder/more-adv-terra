resource "aws_placement_group" "asg-pg" {
  name     = "ASG-template"
  strategy = "spread"
  tags = {
    Name = "launch configuration for ASG"
  }
}

resource "aws_autoscaling_group" "asg" {
  availability_zones        = ["eu-central-1a"]
  name                      = "ASG-terra"
  load_balancers            = [aws_elb.ELB.id]
  max_size                  = 2
  health_check_grace_period = 1000
  health_check_type         = "ELB"
  min_size                  = 1
  placement_group           = aws_placement_group.asg-pg.id
  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity = 2
    }
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.LTforASG.id
        version            = "$Latest"
      }
    }
  }
 tags = [
      {
      key                 = "Name"
      value               = "ASG_instance"
      propagate_at_launch = true
       },
      {
      key                 = "Role"
      value               = "nginx for now"
      propagate_at_launch = true
      }
    ]
}
