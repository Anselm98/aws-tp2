resource "aws_instance" "nginx_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
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