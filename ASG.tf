resource "aws_placement_group" "asg-pg" {
  name     = "ASG-template"
  strategy = "spread"
  tags = {
    Name = "launch configuration for ASG"
  }
}


resource "aws_autoscaling_group" "asg" {
  availability_zones    = ["eu-central-1a"]
  name                  = "ASG-terra"
  max_size              = 2
  min_size              = 1
  default_cooldown      = 5
  desired_capacity      = 2
  force_delete          = true
  protect_from_scale_in = true
  placement_group       = aws_placement_group.asg-pg.id
  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity = 1
    }
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.LTforASG.id
      }
    }
  }
}
