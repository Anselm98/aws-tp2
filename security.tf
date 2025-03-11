resource "aws_security_group" "nginx_sg" {
  name        = "nginx-sg"
  description = "Allow HTTP, SSH traffic and MySQL connections to RDS"
  vpc_id      = aws_vpc.main.id
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH"
  }
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP"
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  # No need to add explicit MySQL outbound rule since we allow all outbound traffic
}

# Security group for private instance
resource "aws_security_group" "private_sg" {
  name        = "private-sg"
  description = "Security group for private instance"
  vpc_id      = aws_vpc.main.id
  
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.nginx_sg.id]
    description     = "SSH from public instances"
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
  
  tags = {
    Name = "private-sg"
  }
}

# Security group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Security group for RDS database"
  vpc_id      = aws_vpc.main.id

  # MariaDB/MySQL standard port - only allow from nginx server
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.nginx_sg.id]
    description     = "MariaDB access from web server"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "rds-security-group"
  }
}