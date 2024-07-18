variable "region" {
  description = "Value of region"
  type        = string
  default     = "us-east-1"
}
variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet within the VPC"
  type        = string
}

variable "public_key" {
  description = "The public key to use for the instance"
  type        = string
}
