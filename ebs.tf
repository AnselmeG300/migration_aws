# --------------------------------------------------------
### Deploy elastic block store volume

resource "aws_ebs_volume" "wordpress_ebs" {
  availability_zone = var.AZ
  size              = var.size
}

