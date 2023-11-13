

### Security Groups
resource "aws_security_group" "wordpress_ebs" {
  name        = "wordpress_ebs"
  # vpc_id      = "vpc-04bdf742e2617c0ef"
  description = "WordPress EBS"
}

resource "aws_security_group" "wordpress_db" {
  name        = "wordpress_db"
  # vpc_id      = "vpc-04bdf742e2617c0ef"
  description = "WordPress Database"
}

resource "aws_security_group" "wordpress" {
  name        = "wordpress"
  # vpc_id      = "vpc-04bdf742e2617c0ef"
  description = "WordPress EC2"
}

resource "aws_security_group" "wordpress_ssh" {
  name        = "WordPress ssh"
  # vpc_id      = "vpc-04bdf742e2617c0ef"
  description = "traffic ssh."
}





# --------------------------------------------------------
### Security group rules

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



# EC2 > Any : Ephemeral
resource "aws_security_group_rule" "ec2_egress_reply" {
  security_group_id = aws_security_group.wordpress.id
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "all"
  from_port         = 1024
  to_port           = 65535
}

# EC2 < Any : Ephemeral
resource "aws_security_group_rule" "ec2_ingress_reply" {
  security_group_id = aws_security_group.wordpress.id
  type              = "ingress"
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
  cidr_blocks       = ["${aws_instance.wordpress.private_ip}/32"]
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
