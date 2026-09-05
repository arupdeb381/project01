resource "aws_subnet" "public-subnet-01-1a" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "${var.env}-public-snet-01-1a"
    Env  = var.env
  }
}

resource "aws_subnet" "public-subnet-02-1b" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "${var.env}-public-snet-02-1b"
    Env  = var.env
  }
}

resource "aws_subnet" "private-subnet-01-1a" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "${var.env}-private-snet-01-1a"
    Env  = var.env
  }
}

resource "aws_subnet" "private-subnet-02-1b" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = "10.0.12.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "${var.env}-private-snet-02-1b"
    Env  = var.env
  }
}