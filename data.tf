data "aws_ami" "ubuntu" {
  owners = ["099720109477"] 
  
  filter {
    name   = "image-id"
    values = ["ami-04b4f1a9cf54c11d0"]
  }
  
}