variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  type        = string
  description = "CIDR block for the subnet"
  default     = "10.0.10.0/24"
}

variable "avail_zone" {
  type        = string
  description = "Availability zone for the subnet"
  default     = "ap-south-1a"
}

variable "env_prefix" {
  type        = string
  description = "Environment prefix for naming"
  default     = "prod"
}

variable "my_ip" {
  type        = string
  description = "My IP address"
  default     = "146.196.47.73"
}

variable "jenkins_ip" {
  type        = string
  description = "Jenkins server's IP address"
  default     = "139.59.3.226"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro"
}
