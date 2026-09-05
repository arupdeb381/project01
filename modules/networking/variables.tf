variable "project_name" {
  description = "Project name"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs"
  type        = list(string)
}

variable "database_subnet_cidrs" {
  description = "Database subnet CIDRs"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
}

variable "enable_nat" {
  description = "Enable NAT gateway"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}