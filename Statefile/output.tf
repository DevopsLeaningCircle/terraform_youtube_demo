output "instance_id" {
  value = aws_instance.iac_instance.id
}

output "vpc_id" {
  value = aws_vpc.iac_vpc.id
}
