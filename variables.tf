variable "region" {
  description = "AWS region"
}

variable "name" {
  description = "waf acl name"
}

variable "description" {
  description = "waf acl description"
}

variable "alb_arns" {
  description = "list of ELBs to associate"
}

variable "environment" {
  description = "aws environment"
}

variable "additional_tags" {
  default = {
    Terraform      = "true"
  }
  description = "Additional resource tags"
  type        = map(string)
}
