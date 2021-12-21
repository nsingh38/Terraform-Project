variable "vpc_cidr" {
  type        = string
  description = "Enter your vpc cidr here"
}

variable "public_subnet_cidr" {
  type        = list(string)
  description = "Enter your public subnet cidr here"
}

variable "private_subnet_cidr" {
  type        = list(string)
  description = "Enter your private subnet cidr here"
}

variable "subnet_az" {
  type        = list(string)
  description = "Enter your subnet availability zone here"
}
