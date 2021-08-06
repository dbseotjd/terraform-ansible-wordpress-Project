output "public_ip" {
  description = "Public IP of Instance"
  value       = aws_instance.my_instance.public_ip
}

#output "elastic_ip" {
#  description = "Elastic IP of Instance"
#  value       = aws_eip.my_eip.public_ip
#}
