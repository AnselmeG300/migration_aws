provider "aws" {
  region     = "eu-west-2"
  access_key = ""
  secret_key = ""
}


resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/xvda"
  volume_id   = aws_ebs_volume.wordpress_ebs.id
  instance_id = aws_instance.wordpress.id
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.wordpress.id
  allocation_id = aws_eip.my_eip.id
}
