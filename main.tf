# you are creating a provider
provider "aws" {
  region = "us-east-1"
}

#You are creating a resource with an ami and running a bash script.
#nohub will keep the webserver in running mode

resource "aws_launch_configuration"  "example" {
  image_id      = "ami-0cfee17793b08a293"
  instance_type = "t2.micro"
  # you are referening to another resource created later.
  security_groups  = [aws_security_group.awssg.id]
  user_data = <<-EOF
              #!/bin/bash
              echo "Welcome to the world of Terraform" > index.html
              nohup busybox httpd -f -p ${var.server_port} & 
              EOF

# Required when using a launch configuration with an auto scaling group.
  # https://www.terraform.io/docs/providers/aws/r/launch_configuration.html
  lifecycle {
    create_before_destroy = true
  }
}


#the following resource is important because, you cannot the webserver
#you created in the above statement without opening the port 8080


resource "aws_security_group" "awssg" {
  name = "awssg"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
}

#variable for server_port

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

# the following piece of code will get the subnet ids from AWS API

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

# autoscaling group - cluster of webservers
resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.name
  vpc_zone_identifier  = data.aws_subnet_ids.default.ids
  min_size = 2
  max_size = 10

  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
  }
}
