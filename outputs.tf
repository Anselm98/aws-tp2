output "nginx_public_ip" {
  value       = aws_instance.nginx_server.public_ip
  description = "The public IP address of the nginx server"
}

output "nginx_instance_id" {
  value       = aws_instance.nginx_server.id
  description = "The ID of the nginx EC2 instance"
}

output "private_instance_id" {
  value       = aws_instance.private_instance.id
  description = "The ID of the private EC2 instance"
}

output "private_instance_private_ip" {
  value       = aws_instance.private_instance.private_ip
  description = "The private IP address of the private instance"
}

output "nat_gateway_public_ip" {
  value       = aws_nat_gateway.nat.public_ip
  description = "The public IP address of the NAT Gateway"
}

output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The ID of the VPC"
}
