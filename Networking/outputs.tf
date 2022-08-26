output "vpc_id"{
  value = aws_vpc.huy_vpc.id
}
output "db_subnet_group_name"{
  value = aws_db_group.huy_rds_subnetgroup.*.name
}

output "db_security_group"{
  value = [aws_security_group.huy_sg["rds"].id]
}

output "public_sg"{
  value = aws_security_group.huy_sg["public"].id
}

output "public_subnets"{
  value = aws_subnets.huy_public_subnet.*.id
}
