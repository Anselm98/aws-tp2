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

# RDS subnet group - RDS requires at least 2 subnets in different AZs
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.public.id, aws_subnet.private.id]

  tags = {
    Name = "RDS Subnet Group"
  }
}

# RDS instance using MariaDB
resource "aws_db_instance" "db" {
  allocated_storage      = 20
  storage_type           = "gp3"
  engine                 = "mariadb"
  engine_version         = "10.6"
  instance_class         = "db.t3.micro"
  identifier             = "mydb"
  username               = "admin"
  password               = "cHpM57*B9%PSC!ZOVnA2"  # Use secrets manager in production
  parameter_group_name   = "default.mariadb10.6"
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible    = true  # Since it's in a public subnet
  skip_final_snapshot    = true
  
  # Enable encryption at rest for secure communications
  storage_encrypted = true
  
  tags = {
    Name = "MyMariaDBInstance"
  }
}

# Output the endpoint for easy access
output "rds_endpoint" {
  value       = aws_db_instance.db.endpoint
  description = "The endpoint of the RDS database"
}