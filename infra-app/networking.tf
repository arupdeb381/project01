resource "aws_vpc" "my-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${var.env}-infra-app-vpc"
    Env  = var.env
  }
}

resource "aws_subnet" "web_snet-01-1a" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env}-infra-WEB-subnet-01-1a"
    Env  = var.env
  }
}

resource "aws_subnet" "web_snet-02-1b" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env}-infra-WEB-subnet-02-1b"
    Env  = var.env
  }
}

resource "aws_subnet" "app_snet-01-1a" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "${var.aws_region}a"
  tags = {
    Name = "${var.env}-infra-APP-subnet-01-1a"
    Env  = var.env
  }
}

resource "aws_subnet" "app_snet-02-1b" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = "10.0.12.0/24"
  availability_zone = "${var.aws_region}b"
  tags = {
    Name = "${var.env}-infra-APP-subnet-02-1b"
    Env  = var.env
  }
}


resource "aws_subnet" "db_snet-01-1a" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = "10.0.21.0/24"
  availability_zone = "${var.aws_region}a"
  tags = {
    Name = "${var.env}-infra-DB-subnet-01-1a"
    Env  = var.env
  }
}

resource "aws_subnet" "db_snet-02-1b" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = "10.0.22.0/24"
  availability_zone = "${var.aws_region}b"
  tags = {
    Name = "${var.env}-infra-DB-subnet-02-1b"
    Env  = var.env
  }
}


resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name = "${var.env}-infra-web-igw"
    Env  = var.env
  }
}

resource "aws_security_group" "WebSG" {
  name        = "${var.env}-infra-app-web-sg"
  description = "Security group for the web application"
  vpc_id      = aws_vpc.my-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.my-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }
}

resource "aws_route_table_association" "public-subnet-01-1a-association" {
  subnet_id      = aws_subnet.web_snet-01-1a.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "public-subnet-02-1b-association" {
  subnet_id      = aws_subnet.web_snet-02-1b.id
  route_table_id = aws_route_table.public-rt.id
}


resource "aws_security_group" "app-sg" {
  name        = "${var.env}-infra-app-private-sg"
  description = "Security group for private instances"
  vpc_id      = aws_vpc.my-vpc.id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    security_groups = [aws_security_group.WebSG.id]
    }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db-sg" {
  name        = "${var.env}-infra-db-sg"
  description = "Security group for database instances"
  vpc_id      = aws_vpc.my-vpc.id
    ingress {
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        security_groups = [aws_security_group.app-sg.id]
    }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}



###### NAT GW ##########

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
  
  tags = {
    Name = "${var.env}-nat-eip"
    Env  = var.env
  }
}

# NAT Gateway in public subnet
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.web_snet-01-1a.id
  
  tags = {
    Name = "${var.env}-nat-gw"
    Env  = var.env
  }
}

# Private route table with NAT gateway
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.my-vpc.id
  
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  
  tags = {
    Name = "${var.env}-private-rt"
    Env  = var.env
  }
}

# Associate private subnets with private route table
resource "aws_route_table_association" "private-subnet-01-1a-association" {
  subnet_id      = aws_subnet.app_snet-01-1a.id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_route_table_association" "private-subnet-02-1b-association" {
  subnet_id      = aws_subnet.app_snet-02-1b.id
  route_table_id = aws_route_table.private-rt.id
}


