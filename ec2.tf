resource "aws_instance" "wordpress" {
  ami               = "ami-0505148b3591e4c07"
  key_name          = "devops-key"
  availability_zone = var.AZ
  instance_type     = var.ec2_instance_type

  vpc_security_group_ids = ["${aws_security_group.wordpress.id}",
    "${aws_security_group.wordpress_ebs.id}",
    "${aws_security_group.wordpress_db.id}",
    "${aws_security_group.wordpress_ssh.id}"
  ]

  tags = {
    Name = "${var.maintainer}"
  }

  provisioner "local-exec" {
    command = "echo PUBLIC IP: ${self.public_ip}"
  }


  provisioner "remote-exec" {

    inline = [
      "mkdir -p migration",                                                  # Créez le dossier de destination
      "echo '${file("docker-compose.yml")}' > migration/docker-compose.yml",
      "echo '${file(".env")}' > migration/.env",# Copie le contenu du fichier env
      "sudo curl -fsSL https://get.docker.com -o get-docker.sh",
      "sudo sh get-docker.sh",
      "sudo usermod -aG docker ubuntu",
      "sudo systemctl restart docker",
      "sudo systemctl enable docker",
      "sudo curl -L https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose",
      "cd migration",                       # Accédez au dossier de destination
      "sudo /usr/local/bin/docker-compose up -d", # Lancez le Docker Compose en arrière-plan"

    ]

    connection {
      type        = "ssh"
      user        = var.user
      private_key = file("./devops-key.pem")
      host        = self.public_ip
    }
  }

}

