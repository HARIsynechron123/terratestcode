terraform {
   required_version = ">= 0.12.26"
}

provider "aws" {
  region = "us-east-2"
  access_key = "AKIAXXTFJVECDB666KUH"
  secret_key = "9bb0ujbwXZuOh017XnTNYB52rk1OEiJL64HsM5g9"
}

# Deploy an EC2 Instance.
resource "aws_instance" "example" {
  # Run an Ubuntu 18.04 AMI on the EC2 instance.
  ami                    = "ami-0d5d9d301c853a04a"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  # When the instance boots, start a web server on port 8080 that responds with "Hello, World!".
  user_data = <<EOF
#!/bin/bash
echo "Hello, World!" > index.html
nohup busybox httpd -f -p 8080 &
EOF
}

# Allow the instance to receive requests on port 8080.
resource "aws_security_group" "instance" {
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Output the instance's public IP address.
output "public_ip" {
  value = aws_instance.example.public_ip
}