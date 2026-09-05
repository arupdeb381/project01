# Key pair 
resource "aws_key_pair" "my_key_pair" {
  key_name   = "${var.env}-terra-key-ec2"
  public_key = file("infra-app/terra-key-ec2.pub")

  tags = {
    Environment = var.env
  }

}

# VPC & Security Group
resource "aws_vpc" "my-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${var.env}-my-vpc"
    Env  = var.env
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "${var.env}-public-snet"
    Env  = var.env
  }
}

resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name = "${var.env}-my-igw"
    Env  = var.env
  }
}

resource "aws_route_table" "my-route-table" {
  vpc_id = aws_vpc.my-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }
  tags = {
    Name = "${var.env}-my-route-table"
    Env  = var.env
  }
}

resource "aws_route_table_association" "public-subnet-association" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.my-route-table.id
}


resource "aws_security_group" "my-security-group" {
  name        = "${var.env}-my-security-group"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = aws_vpc.my-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH from specific IP"
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP from specific IP"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }


  tags = {
    Name = "${var.env}-my-security-group"
    Env  = var.env

  }

}

# EC2 Instance
resource "aws_instance" "my-ec2-instance" {
  depends_on = [aws_security_group.my-security-group]
  count = var.instance_count
  ami                         = var.ec2_image_id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.my_key_pair.key_name
  vpc_security_group_ids      = [aws_security_group.my-security-group.id]
  associate_public_ip_address = var.public_ip_attachment
  subnet_id                   = aws_subnet.public-subnet.id
  root_block_device {
    volume_size = var.env == "prod" ? 20 : var.ec2_root_default_vol_size
    volume_type = "gp2"
  }
  user_data = file("infra-app/install_nginx.sh")

  tags = {
    Name = "${var.env}-infra-app-ec2-${format("%02d", count.index + 1)}"
    Env  = var.env
  }
}

