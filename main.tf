# you are creating a provider
provider "aws" {
  region = "us-east-1"
}

#You are creating a resource with an ami and running a bash script.
#nohub will keep the webserver in running mode

resource "aws_instance" "example" {
  ami           = "ami-0cfee17793b08a293"
  instance_type = "t2.micro"

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

   tags = {
    Name = "terraform-example"
  }
}

#the following resource is important because, you cannot the webserver
#you created in the above statement without opening the port 8080

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


