variable "vpc_id" {
  type = string
}
variable "private_subnets_id" {
  type = list(string)
}

variable "tg-arn" {
  type = string
}
