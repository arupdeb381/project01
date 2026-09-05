variable "key_name" {
  description = "The name of the key pair to create."
  type        = string
}

variable "public_key_path" {
  description = "The path to the public key file."
  type        = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "env" {
  description = "The environment for the infrastructure (e.g., dev, prod)."
  type        = string
}

variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
}

variable "ec2_image_id" {
  description = "The AMI ID for the EC2 instance."
  type        = string
}

variable "instance_type" {
  description = "The instance type for the EC2 instance."
  type        = string
}

variable "public_ip_attachment" {
  description = "Whether to associate a public IP address with the EC2 instance."
  type        = bool
}

variable "ec2_root_default_vol_size" {
  description = "The default root volume size for the EC2 instance."
  type        = number
}

##### postgress SQL RDS variables
variable "db_instance_class" {
  description = "The instance class for the RDS PostgreSQL instance."
  type        = string
}

variable "db_name" {
  description = "The name of the database to create."
  type        = string
}

variable "db_username" {
  description = "The username for the database."
  type        = string
}

variable "db_password" {
  description = "The password for the database."
  type        = string
  sensitive   = true
}

variable "db_storage_size" {
  description = "The allocated storage size for the RDS PostgreSQL instance (in GB)."
  type        = number
}

variable "db_engine_version" {
  description = "The engine version for the RDS PostgreSQL instance."
  type        = string
}

