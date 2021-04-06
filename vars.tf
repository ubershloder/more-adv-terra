variable "username" {
  description = "db_username"
  type        = string
  sensitive   = true
  default     = "terraform"
}
variable "password" {
  description = "db_password"
  type        = string
  sensitive   = true
  default     = "terraform"
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
  type        = string
  default     = "0.0.0.0/0"
}
variable "asg_health" {
  description = "health check grace period"
  type        = string
  default     = 1000
}
