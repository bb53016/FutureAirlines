
resource "aws_instance" "test_instance" {
  ami                    = "${var.ami}"
  instance_type          = "${var.ins_type}"
  subnet_id              = "${var.subnet_id}"
  key_name               = "${var.keyname}"
  vpc_security_group_ids = ["${var.security_groups_ec2_id}", "${var.mgmt_sg_id}"]
  iam_instance_profile   = "${var.iam_instance_profile}"

  ebs_optimized = "${var.ebs_optimized}"

  root_block_device {
    volume_size = "${var.volume_size}"
    encrypted = "true"
  }

  availability_zone = "${var.availability_zone}"
  monitoring = true

  tags {
    Name                   = "${var.stack_name}-${var.tag_env}"
    Owner                  = "${var.tag_Owner}"
    Team                   = "${var.tag_team}"
    Role                   = "${var.tag_role}"
  }
}
