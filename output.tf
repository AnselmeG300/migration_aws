output "output_rds_host" {
  value = aws_db_instance.wordpress.address
}

output "output_sg_name1" {
  value = aws_security_group.wordpress.name
}

output "output_sg_name2" {
  value = aws_security_group.wordpress_db.name
}

output "output_sg_name3" {
  value = aws_security_group.wordpress_ebs.name
}

output "output_sg_name4" {
  value = aws_security_group.wordpress_elb.name
}

output "output_elb" {
  value = aws_elb.wordpress.dns_name
}

output "output_eip" {
  value = aws_eip.my_eip.public_ip
}

output "output_eip_id" {
  value = aws_eip.my_eip.id
}

output "output_ec2_id" {
  value = aws_instance.wordpress.id
}


output "output_ec2_AZ" {
  value = aws_instance.wordpress.availability_zone
}

output "output_ec2_private_ip" {
  value = aws_instance.wordpress.private_ip
}

output "output_ec2_ami" {
  value = aws_instance.wordpress.ami
}

output "output_id_volume" {
  value = aws_ebs_volume.wordpress_ebs.id
}


