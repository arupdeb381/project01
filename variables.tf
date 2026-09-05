variable "env" {
  description = "This is the Environment for my infrastructure"
  type        = string
}

variable "bucket_name" {
  description = "This is the name of the S3 bucket for Terraform state"
  type        = string
}

variable "ec2_image_id" {
  description = "This is the AMI ID for the EC2 instance"
  type    = string
}

variable "ec2_root_default_vol_size" {
  description = "This is the default volume size for the EC2 root block device"
  type    = number
}

variable "public_ip_attachment" {
  description = "This is whether to attach a public IP address to the EC2 instance"
  type    = bool
}

variable "instance_count" {
  description = "This is the number of EC2 instances to create"
  type        = number
}

variable "instance_type" {
  description = "This is the instance type for the EC2 instance"
  type        = string
}

variable "hash_key" {
  description = "This is the hash key for the DynamoDB table"
  type        = string
}

