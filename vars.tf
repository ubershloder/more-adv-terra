variable "password" {
  description = "Pass for DB"
  type        = string
}
variable "username" {
  description = "DB username"
  type        = string
}
variable "cluster_name" {
  description = "Name of ASG cluster"
  type        = string
  default     = "Terra-"
}
variable "orchestrator_port" {
  description = "port for SG"
  type        = string
  default     = "2377"
}
variable "all_cidr" {
description = "allow connection from everywhere"
type = string
default = "0.0.0.0/0"
}
variable "asg_health" {
description = "health check grace period"
type = string
default = 1000
}
