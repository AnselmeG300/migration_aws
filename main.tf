provider "aws" {
  region     = "eu-west-1"
}


resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.wordpress_ebs.id}"
  instance_id = "${aws_instance.wordpress.id}"
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.wordpress.id
  allocation_id = aws_eip.my_eip.id
}
