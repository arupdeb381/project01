module "dev-infra-app" {
    source = "./infra-app"
    
    # Region
    aws_region = "us-east-1"
    vpc_cidr_block = "10.0.0.0/16"

    # Environment
    env = "dev"
    # EC2 Configuration - Manual Selection
    ec2_image_id = "ami-0332d564d76dbd8d6"      # Amazon Linux 2 AMI
    ec2_root_default_vol_size = 8                # 8GB root volume
    public_ip_attachment = true                  # Assign public IPs
    instance_count = 5                           # Total instances (2 web + 2 app + 1 bastion)
    instance_type = "t3.micro"                   # Instance type for all EC2s
    
    # Database Configuration
    db_name = "appdb"
    db_username = "admin"
    db_password = "SecurePassword123!"
    db_instance_class = "db.t3.micro"
    db_storage_size = 20
    db_engine_version = "13.7"

    # Key Pair
    key_name = "terra-key"
    public_key_path = "infra-app/terra-key-ec2.pub"
}