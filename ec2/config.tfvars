
# Account credentials to run terraform
accessKey = ""
secretKey = ""
aws_account = ""

# VPC parameters
aws_region = "us-west-2"
vpc_cidr = "10.252.141.0/24"
azs = ["us-west-2a", "us-west-2b"]
public_cidrs = ["10.252.141.0/27", "10.252.141.32/27"]
private_cidrs = ["10.252.141.64/27", "10.252.141.96/27"]


# Instance type to launch
instance_type = "t2.micro"

# Security feature to allow packet from specific IP
homeIPAddress = ""

# Tags values
Owner= "Bernard Banamba"
team = "Cloud Team"
stack_name = "Demo"
ami = ""

# AutoScaling Group instance # controls
desired_capacity = "2"
asg_max_child = "3"
asg_min_child = "1"

# Define security group to allow traffic 
security_groups_ec2_id = ""
security_groups_elb_id= ""

am_instance_profile= ""

