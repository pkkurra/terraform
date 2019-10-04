# you are creating a provider
provider "aws" {
  region = "us-east-1"
}

#You are creating a resource with an ami and running a bash script.
#nohub will keep the webserver in running mode

resource "aws_instance" "example" {
  ami           = "ami-0cfee17793b08a293"
  instance_type = "t2.micro"
  # you are referening to another resource created later.
  vpc_security_group_ids = [aws_security_group.awssg.id]
  user_data = <<-EOF
              #!/bin/bash
              echo "Welcome to the world of Terraform" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

   tags = {
    Name = "terraform-example"
  }
}

#the following resource is important because, you cannot the webserver
#you created in the above statement without opening the port 8080

resource "aws_security_group" "awssg" {
  name = "awssg"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  
}


