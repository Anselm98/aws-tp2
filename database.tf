resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.public.id, aws_subnet.private.id]

  tags = {
    Name = "RDS Subnet Group"
  }
}

# RDS instance
resource "aws_db_instance" "db" {
  allocated_storage      = 20
  storage_type           = "gp3"
  engine                 = "mariadb"
  engine_version         = "10.6"
  instance_class         = "db.t3.micro"
  identifier             = "mydb"
  username               = "admin"
  password               = "cHpM57*B9%PSC!ZOVnA2"
  parameter_group_name   = "default.mariadb10.6"
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible    = true
  skip_final_snapshot    = true
  
  storage_encrypted = true
  
  tags = {
    Name = "MyMariaDBInstance"
  }
}

output "rds_endpoint" {
  value       = aws_db_instance.db.endpoint
  description = "The endpoint of the RDS database"
}