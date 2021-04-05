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
