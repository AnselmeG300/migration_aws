

### Security Groups
resource "aws_security_group" "wordpress_ebs" {
  name        = "wordpress_ebs"
  vpc_id      = "vpc-0574466bd4f6eb2d0"
  description = "WordPress EBS"
}
resource "aws_security_group" "wordpress_db" {
  name        = "wordpress_db"
  vpc_id      = "vpc-0574466bd4f6eb2d0"
  description = "WordPress Database"
}

resource "aws_security_group" "wordpress" {
  name        = "wordpress"
  vpc_id      = "vpc-0574466bd4f6eb2d0"
  description = "WordPress EC2"
}

resource "aws_security_group" "wordpress_elb" {
  name        = "WordPress ELB"
  vpc_id      = "vpc-0574466bd4f6eb2d0"
  description = "Control the access to the ELB."
}

resource "aws_security_group" "wordpress_ssh" {
  name        = "WordPress ssh"
  vpc_id      = "vpc-0574466bd4f6eb2d0"
  description = "traffic ssh."
}





# --------------------------------------------------------
### Security group rules

# Any > ELB : HTTP
resource "aws_security_group_rule" "elb_ingress_http" {
  security_group_id = aws_security_group.wordpress_elb.id
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_security_group_rule" "ssh_ingress" {
  security_group_id = aws_security_group.wordpress_ssh.id
  type              = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]
}

resource "aws_security_group_rule" "ssh_egress" {
  security_group_id = aws_security_group.wordpress_ssh.id
  type              = "egress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]
  }

# Any > ELB : HTTPS
resource "aws_security_group_rule" "elb_ingress_https" {
  security_group_id = aws_security_group.wordpress_elb.id
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
}

# ELB > EC2 : HTTP
resource "aws_security_group_rule" "elb_egress_http" {
  security_group_id        = aws_security_group.wordpress_elb.id
  source_security_group_id = aws_security_group.wordpress.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = 80
  to_port                  = 80
}

# ELB > EC2 : HTTPS
resource "aws_security_group_rule" "elb_egress_https" {
  security_group_id        = aws_security_group.wordpress_elb.id
  source_security_group_id = aws_security_group.wordpress.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = 443
  to_port                  = 443
}



# EC2 < ELB : HTTP
resource "aws_security_group_rule" "ec2_ingress_http" {
  security_group_id        = aws_security_group.wordpress.id
  type                     = "ingress"
  source_security_group_id = aws_security_group.wordpress_elb.id
  protocol                 = "tcp"
  from_port                = 80
  to_port                  = 80
}

# EC2 < ELB : HTTPS
resource "aws_security_group_rule" "ec2_ingress_https" {
  security_group_id        = aws_security_group.wordpress.id
  type                     = "ingress"
  source_security_group_id = aws_security_group.wordpress_elb.id
  protocol                 = "tcp"
  from_port                = 443
  to_port                  = 443
}

# EC2 > Any : Ephemeral
resource "aws_security_group_rule" "ec2_egress_reply" {
  security_group_id = aws_security_group.wordpress.id
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "all"
  from_port         = 1024
  to_port           = 65535
}




# --------------------------------------------------------
# RDS

# RDS < EC2 : MySQL
resource "aws_security_group_rule" "rds_ingress_mysql" {
  security_group_id = aws_security_group.wordpress_db.id
  type              = "ingress"
  cidr_blocks       = ["${aws_instance.wordpress.private_ip}" / 32]
  protocol          = "tcp"
  from_port         = 3306
  to_port           = 3306
}

# RDS > Any : MySQL
resource "aws_security_group_rule" "rds_egress_mysql" {
  security_group_id = aws_security_group.wordpress_db.id
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "all"
  from_port         = 0
  to_port           = 65535
}
