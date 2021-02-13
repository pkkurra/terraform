provider "aws" {

	region = "us-east-1"
	
}

resource "aws_instance" "example" {

	ami	= "ami-096fda3c22c1c990a"
	instance_type = "t2.micro"
	
	tags = {
		Name = "terraform-example"
	}

}