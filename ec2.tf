resource "aws_instance" "wordpress" {
  ami               = "ami-0694d931cee176e7d"
  key_name          = "centos"
  availability_zone = var.AZ
  instance_type     = var.ec2_instance_type

  vpc_security_group_ids = [
    aws_security_group.wordpress.id,
    aws_security_group.wordpress_ssh.id
  ]

  tags = {
    Name = var.maintainer
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
      "cd migration",                       # Accédez au dossier de destination
      "echo 'MYSQL_HOST=${aws_db_instance.wordpress.address}' >> .env",                       # Accédez au dossier de destination
      "echo 'MYSQL_PORT=${aws_db_instance.wordpress.port}' >> .env",                       # Accédez au dossier de destination
      "echo 'MYSQL_ROOT_PASSWORD=${var.db_password}' >> .env",                       # Accédez au dossier de destination
      "echo 'MYSQL_DATABASE=${var.db_name}' >> .env",                       # Accédez au dossier de destination
      "echo 'MYSQL_USER=${var.db_username}' >> .env",                       # Accédez au dossier de destination
      "echo 'MYSQL_PASSWORD=${var.db_password}' >> .env",                       # Accédez au dossier de destination
      "sudo docker compose up -d", # Lancez le Docker Compose en arrière-plan"

    ]

    connection {
      type        = "ssh"
      user        = var.user
      private_key = file("./centos.pem")
      host        = self.public_ip
    }
  }

}

