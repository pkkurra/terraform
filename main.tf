
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0cfee17793b08a293"
  instance_type = "t2.micro"
 
   tags = {
    Name = "terraform-example"
  }
}



