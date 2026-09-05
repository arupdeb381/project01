# key pair
resource "aws_key_pair" "key" {
  key_name   = var.key_name
  public_key = file("infra-app/terra-key-ec2.pub")
}

resource "aws_instance" "web-ec2-01" {
    ami           = var.ec2_image_id
    instance_type = var.instance_type
    key_name      = aws_key_pair.key.key_name
    associate_public_ip_address = var.public_ip_attachment
    subnet_id    = aws_subnet.public-subnet-01-1a.id
    user_data = file("modules/infra-app/user-data/web.sh")
    root_block_device {
        volume_size = var.ec2_root_default_vol_size
    }
    
    tags = {
        Name = "${var.env}-web-ec2-01"
        Env  = var.env
    }
}

resource "aws_instance" "web-ec2-02" {
    ami           = var.ec2_image_id
    instance_type = var.instance_type
    key_name      = aws_key_pair.key.key_name
    associate_public_ip_address = var.public_ip_attachment
    subnet_id    = aws_subnet.public-subnet-01-1b.id
    user_data = file("modules/infra-app/user-data/web.sh")
        root_block_device {
        volume_size = var.ec2_root_default_vol_size
    }
    
    tags = {
        Name = "${var.env}-web-ec2-02"
        Env  = var.env
    }
}

resource "aws_instance" "bastion-ec2" {
    ami           = var.ec2_image_id
    instance_type = var.instance_type
    key_name      = aws_key_pair.key.key_name
    associate_public_ip_address = var.public_ip_attachment
        root_block_device {
        volume_size = var.ec2_root_default_vol_size
    }
    
    tags = {
        Name = "${var.env}-bastion-ec2"
        Env  = var.env
    }
}
resource "aws_instance" "app-ec2-01" {
    ami           = var.ec2_image_id
    instance_type = var.instance_type
    key_name      = aws_key_pair.key.key_name
    associate_public_ip_address = var.public_ip_attachment
    subnet_id     = aws_subnet.private-subnet-01-1a.id
    user_data = file("modules/infra-app/user-data/app.sh")
        root_block_device {
        volume_size = var.ec2_root_default_vol_size
    }

    tags = {
        Name = "${var.env}-app-ec2-01"
        Env  = var.env
    }
}

resource "aws_instance" "app-ec2-02" {
    ami           = var.ec2_image_id
    instance_type = var.instance_type
    key_name      = aws_key_pair.key.key_name
    associate_public_ip_address = var.public_ip_attachment
    subnet_id     = aws_subnet.private-subnet-01-1b.id
    user_data = file("modules/infra-app/user-data/app.sh")
        root_block_device {
        volume_size = var.ec2_root_default_vol_size
    }

    tags = {
        Name = "${var.env}-app-ec2-02"
        Env  = var.env
    }
}