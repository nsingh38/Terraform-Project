output "vpc_id" {
  value = aws_vpc.main.id
}

output "private_subnets_id" {
  value = aws_subnet.private_subnets.*.id
}

output "public_subnets_id" {
  value = aws_subnet.public_subnets.*.id
}

output "eip" {
  value = aws_eip.nat_eip.public_ip
}