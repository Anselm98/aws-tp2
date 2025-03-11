output "nginx_public_ip" {
  value       = aws_instance.nginx_server.public_ip
  description = "The public IP address of the nginx server"
}

output "nginx_instance_id" {
  value       = aws_instance.nginx_server.id
  description = "The ID of the nginx EC2 instance"
}