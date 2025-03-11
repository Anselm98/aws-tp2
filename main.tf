# Public instance in the public subnet
resource "aws_instance" "nginx_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  subnet_id              = aws_subnet.public.id
  key_name               = "Fedora"
  
  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y nginx
              systemctl enable nginx
              systemctl start nginx
              
              # Create custom HTML page
              cat > /var/www/html/index.html <<'HTMLEOF'
              <!DOCTYPE html>
              <html>
              <head>
                  <title>TP1</title>
              </head>
              <body>
                  <h1>Bienvenue !</h1>
                  <p>Ce site a ete deploye avec Terraform pour le TP1.</p>
              </body>
              </html>
              HTMLEOF
              EOF
  
  tags = {
    Name = var.instance_name
  }
}

# Private instance in the private subnet
resource "aws_instance" "private_instance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  subnet_id              = aws_subnet.private.id
  key_name               = "Fedora"
  
  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y curl
              echo "Private instance setup complete" > /home/ubuntu/setup_complete.txt
              EOF
  
  tags = {
    Name = "${var.instance_name}-private"
  }
}