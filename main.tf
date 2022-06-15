terraform {
   required_version = ">= 0.12.26"
}

provider "aws" {
  region = "us-east-2"
}

# Deploy an EC2 Instance.
resource "aws_instance" "example" {
  # Run an Ubuntu 18.04 AMI on the EC2 instance.
  ami                    = "ami-0aeb7c931a5a61206"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.sgr-0e23077d115442e5c.instance.id]

  # When the instance boots, start a web server on port 8080 that responds with "Hello, World!".
  user_data = <<EOF
#!/bin/bash
echo "Hello, World!" > index.html
nohup busybox httpd -f -p 8080 &
EOF
}

# Allow the instance to receive requests on port 8080.
data "sgr-0e23077d115442e5c" "instance" {
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
