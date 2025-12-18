##############################
# Création de l'instance EC2 DBT/Airbyte
##############################
resource "aws_instance" "airbyte" {
  ami             = data.aws_ami.amazon_linux.id
  instance_type   = "t3a.xlarge"
  key_name        = aws_key_pair.default.key_name
  security_groups = [aws_security_group.ec2_sg.name]
  root_block_device {
    volume_size = 50
    volume_type = "gp3"
  }
  tags = {
    Name = "ec2-airbyte"
    Environment = "demo"
  }

  ##############################
  # Copier le script d'installation DBT/Airbyte
  ##############################
  provisioner "file" {
    source      = "../airbyte"
    destination = "/home/ec2-user/airbyte"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/${var.key_name}")
      host        = self.public_ip
    }
  }

  ##############################
  # Copier docker-compose.openmetadata.yaml
  ##############################
  provisioner "file" {
    source      = "../docker-compose.openmetadata.yaml"
    destination = "/home/ec2-user/docker-compose.openmetadata.yaml"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/${var.key_name}")
      host        = self.public_ip
    }
  }

  ##############################
  # Exécuter le script d'installation
  ##############################
  provisioner "remote-exec" {
    inline = [
      # Mise à jour et installation des dépendances
      "sudo yum update -y",
      "sudo yum install -y coreutils",
      "sudo amazon-linux-extras enable docker",
      "sudo yum install -y python3-pip git curl unzip java-11-openjdk docker",
      "sudo usermod -aG docker ec2-user",
      "sudo systemctl enable docker",
      "sudo systemctl start docker",

      # Installation de Docker Compose v2 directement
      "DOCKER_COMPOSE_VERSION=2.18.1",
      "sudo curl -SL https://github.com/docker/compose/releases/download/v2.18.1/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose",

      # Ajout du chemin pour que docker-compose soit trouvé
      "echo 'export PATH=$PATH:/usr/local/bin' >> /home/ec2-user/.bashrc",
      "export PATH=$PATH:/usr/local/bin",

      # Installation de DBT
      #"pip3 install dbt-core dbt-iceberg dbt-postgres",

      # Installation de Airbyte
      "sudo curl -LsfS https://get.airbyte.com | bash",
      "sleep 5",
      "sudo chmod 666 /var/run/docker.sock",

      # Lancer l'installation en arrière-plan
      "bash /home/ec2-user/dbt_airbyte/install_airbyte.sh",

      "sudo /usr/local/bin/docker-compose -f /home/ec2-user/docker-compose.openmetadata.yaml up -d"

      # Lancer la configuration en arrière-plan
      #"abctl local credentials --email admin123@yopmail.com --password admin123admin"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/${var.key_name}")
      host        = self.public_ip
    }
  }
}