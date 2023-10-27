output "output_rds_host" {
  value = aws_db_instance.wordpress.address
}

output "output_eip" {
  value = aws_eip.my_eip.public_ip
}



