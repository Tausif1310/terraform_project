# Key-pair (login)

resource "aws_key_pair" "my_key" {

  key_name   = "terra-key-ec2"
  public_key = file("terra-key-ec2.pub")

}

# VPC & security groups

resource "aws_default_vpc" "default" {



}

resource "aws_security_group" "my_security_group" {

  name        = "tausif_SG"
  description = "this will add a TF genrated Security group"
  vpc_id      = aws_default_vpc.default.id #interpolation 

  tags = {
    Name = "tausif_SG"
  }

  #inbound_rule 

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH open"

  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP open"

  }

  ingress {

    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "flask app"


  }

  #outbound rules 

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = " all access open outbound "




  }

}

#Ec2 isntance 

resource "aws_instance" "my_instance" {

  # count = 2 #meta arguments
  for_each = tomap({

    "TWS-Junoon-automate-micro"  = "t3.micro",
    "TWS-Junoon-automate-small" = "t3.small"


  })

  depends_on = [ aws_security_group.my_security_group, aws_key_pair.my_key ]

  ami             = var.ec2_ami_id #ubuntu
  instance_type   = each.value
  key_name        = aws_key_pair.my_key.key_name
  security_groups = [aws_security_group.my_security_group.name]
  # user_data_base64  = file ("install_nginx.sh")
  # vpc_security_group_ids = [aws_security_group.my_security_group.id] 
  root_block_device {
    volume_size = var.env == "prd" ? 20 : var.ec2_default_root_storage_size #conditional statement 
    volume_type = "gp3"


  }

  tags = {
    name = each.key
  }

}
