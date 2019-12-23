variable "accessKey" {
	default = ""
}

variable "secretKey" {
	default = ""
}
variable "aws_account" {}


variable "aws_region" {
	default = "us-west-2"
}

variable "vpc_cidr" {}

variable "public_cidrs" {
	type = "list"
}
variable "private_cidrs" {
	type = "list"
}

variable "azs" {
	type = "list"
}

variable "instance_type" {
  default = "t2.nano"
}

variable "homeIPAddress" {
	default = ""
}

variable "Owner" {
	default = "Bernard Banamba (bbanamba@parkland.ca)"
}
variable "team"                     {}
variable "stack_name"                   {}

variable "ami" {
type = "string"
  description = "base AMI"
  default = ""
}

# asg variables
variable "asg_max_child"                {}
variable "asg_min_child"                {}
variable "desired_capacity" {}




variable "security_groups_ec2_id" {
type = "string"
  description = "id of the ec2 security group created below"
  default = ""
}
variable "security_groups_elb_id" {
type = "string"
  description = "id of the elb security group created below"
  default = ""
}

variable "iam_instance_profile" {
type = "string"
  description = "EC2 profile"
  default = ""
}

/*
# ASG Variables
variable "asg_evaluation_periods_so"   {}
variable "asg_evaluation_periods_si"   {}
variable "asg_period_so"               {}
variable "asg_period_si"               {}
variable "asg_threshold_so"            {}
variable "asg_threshold_si"            {}
variable "asg_namespace"               {}
variable "asg_metric_name"             {}
variable "asg_statistic"               {}
*/
