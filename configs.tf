variable "default_project_name" {
  default = "PROJECT"
}

variable "default_environment_name" {
  default = "ENV"
}

variable "default_service_name" {
  default = "TEST_SERVICE"
}

variable "vpc" {
  default = ""
}

variable "subnets" {
  default = []
}

variable "alb_target_group_arn" {
  default = ""
}

variable "availability_zones" {
  default = []
}

variable "sequrity_group_port" {
  default = ""
}

variable "alb_target_group_protocol" {
  default = ""
}
