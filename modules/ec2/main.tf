# Key pair 
resource "aws_key_pair" "my_key_pair" {
  key_name   = "${var.env}-terra-key-ec2"
  public_key = file("infra-app/terra-key-ec2.pub")

  tags = {
    Environment = var.env
  }

}
# EC2 Instance
resource "aws_instance" "my-ec2-instance" {
  depends_on = [aws_security_group.WebSG]
  count = var.instance_count
  ami                         = var.ec2_image_id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.my_key_pair.key_name
  vpc_security_group_ids      = [aws_security_group.WebSG.id]
  associate_public_ip_address = var.public_ip_attachment
  subnet_id                   = aws_subnet.public-subnet-01-1a.id
  root_block_device {
    volume_size = var.env == "prod" ? 20 : var.ec2_root_default_vol_size
    volume_type = "gp2"
  }
  user_data = file("ec2/install_nginx.sh")

  tags = {
    Name = "${var.env}-infra-app-ec2-${format("%02d", count.index + 1)}"
    Env  = var.env
  }
}

