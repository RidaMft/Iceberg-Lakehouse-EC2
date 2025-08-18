##############################
# Clé SSH pour accéder à l'EC2
##############################
resource "aws_key_pair" "default" {
  key_name   = var.key_name
  public_key = file("~/.ssh/${var.key_name}.pub")
}

##############################
# Création de l'instance EC2
##############################
resource "aws_instance" "ec2" {
  ami             = data.aws_ami.amazon_linux.id
  instance_type   = "t3.xlarge"
  key_name        = aws_key_pair.default.key_name
  security_groups = [aws_security_group.ec2_sg.name]
  root_block_device {
    volume_size = 100 # Go, ou plus selon ton besoin
    volume_type = "gp3"
  }
  tags = {
    Name = "ec2-iceberg"
    Environment = "demo"
  }

  ##############################
  # Copier docker-compose.yml
  ##############################
  provisioner "file" {
    source      = "../docker-compose.yml"
    destination = "/home/ec2-user/docker-compose.yml"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/${var.key_name}")
      host        = self.public_ip
    }
  }

  ##############################
  # Copier le fichier .env
  ##############################
  provisioner "file" {
    source      = "../.env"
    destination = "/home/ec2-user/.env"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/${var.key_name}")
      host        = self.public_ip
    }
  }

  ##############################
  # Copier le fichier Dockerfile.spark
  ##############################
  provisioner "file" {
    source      = "../Dockerfile.spark"
    destination = "/home/ec2-user/Dockerfile.spark"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/${var.key_name}")
      host        = self.public_ip
    }
  }

  ##############################
  # Copier le dossier trino/
  ##############################
  provisioner "file" {
    source      = "../trino"
    destination = "/home/ec2-user/trino"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/${var.key_name}")
      host        = self.public_ip
    }
  }

  ##############################
  # Copier le dossier notebooks/
  ##############################
  provisioner "file" {
    source      = "../notebooks"
    destination = "/home/ec2-user/notebooks"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/${var.key_name}")
      host        = self.public_ip
    }
  }

  ##############################
  # Copier le dossier db-scripts
  ##############################
  provisioner "file" {
    source      = "../db-scripts"
    destination = "/home/ec2-user/db-scripts"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/${var.key_name}")
      host        = self.public_ip
    }
  }

  ##############################
  # Copier le dossier spark
  ##############################
  provisioner "file" {
    source      = "../spark"
    destination = "/home/ec2-user/spark"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/${var.key_name}")
      host        = self.public_ip
    }
  }

  ##############################
  # Copier le dossier superset/
  ##############################
  provisioner "file" {
    source      = "../superset"
    destination = "/home/ec2-user/superset"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/${var.key_name}")
      host        = self.public_ip
    }
  }

  ##############################
  # Installation Docker & Docker Compose + lancement containers
  ##############################
  provisioner "remote-exec" {
    inline = [
      # 1️⃣ Mise à jour et installation de Docker
      "sudo yum update -y",
      "sudo amazon-linux-extras enable docker",
      "sudo yum install -y docker",
      "sudo systemctl enable docker",
      "sudo systemctl start docker",
      "sudo usermod -aG docker ec2-user",

      # 2️⃣ Installation de Docker Compose v2 directement
      "DOCKER_COMPOSE_VERSION=2.18.1",
      "sudo curl -SL https://github.com/docker/compose/releases/download/v2.18.1/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose",

      # 3️⃣ Ajout du chemin pour que docker-compose soit trouvé
      "echo 'export PATH=$PATH:/usr/local/bin' >> /home/ec2-user/.bashrc",
      "export PATH=$PATH:/usr/local/bin",

      # 4️⃣ Vérification de Docker et Docker Compose
      "docker --version",
      "docker-compose --version",

      # 5️⃣ Démarrage des containers
      "sudo /usr/local/bin/docker-compose build --progress=plain",
      "sudo /usr/local/bin/docker-compose -f /home/ec2-user/docker-compose.yml --env-file /home/ec2-user/.env up -d"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/${var.key_name}")
      host        = self.public_ip
    }
  }
}
