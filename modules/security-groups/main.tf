
resource "aws_security_group" "WebSG" {
  name        = "${var.env}-web-sg"
  description = "Allow SSH from my IP and HTTP traffic"
  vpc_id      = aws_vpc.my-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["223.223.149.175/32"]
    description = "Allow SSH from specific IP"
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP from all"
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS from all"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "${var.env}-web-sg"
    Env  = var.env

  }

}

resource "aws_security_group" "AppSG" {
  name        = "${var.env}-app-sg"
  description = "Allow traffic from WebSG"
  vpc_id      = aws_vpc.my-vpc.id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    security_groups = [aws_security_group.WebSG.id]
    description = "Allow HTTP from all"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
  tags = {
    Name = "${var.env}-app-sg"
    Env  = var.env
  }

}

resource "aws_security_group" "DBSG" {
  name        = "${var.env}-db-sg"
  description = "Allow traffic from AppSG"
  vpc_id      = aws_vpc.my-vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.AppSG.id]
    description = "Allow MySQL from AppSG"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
  tags = {
    Name = "${var.env}-db-sg"
    Env  = var.env
  }
}


