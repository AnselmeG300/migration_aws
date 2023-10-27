### Deploy ELB pointing to EC2
resource "aws_elb" "wordpress" {
  name                        = "wordpress-elb"
  instances                   = ["${aws_instance.wordpress.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 300
  connection_draining         = true
  connection_draining_timeout = 300
  security_groups             = ["${aws_security_group.wordpress_elb.id}"]
  #subnets                     = ["${data.aws_subnet.wordpress.id}"]


  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  # ELB with SSL certificate configured

  listener {
    instance_port      = 443
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = var.elb_ssl_cert
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  tags = var.tags
}