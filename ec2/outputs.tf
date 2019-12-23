
output "instance_ip" {
  value = "${aws_instance.test-instance.private_ip}"
}

output "instance_id" {
  value = "${aws_instance.test-instance.id}"
}
