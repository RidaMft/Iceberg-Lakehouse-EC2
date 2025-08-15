# main.tf

##############################
# 1️⃣ Récupération de l'AMI
##############################
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["137112412989"] # Amazon

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

##############################
# 2️⃣ Clé SSH pour accéder à l'EC2
##############################
resource "aws_key_pair" "default" {
  key_name   = var.key_name
  public_key = file("~/.ssh/${var.key_name}.pub")
}

##############################
# 3️⃣ Récupération du VPC par défaut
##############################
data "aws_vpc" "default" {
  default = true
}

##############################
# 4️⃣ Security Group pour EC2 avec Docker services
##############################
resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Security group pour EC2 avec Docker services"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr]
  }

  ingress {
    description = "Minio"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "MinIO Console UI"
    from_port   = 9001
    to_port     = 9001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jupyter UI"
    from_port   = 8888
    to_port     = 8888
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Iceberg REST Catalog"
    from_port   = 8181
    to_port     = 8181
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Trino"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Superset"
    from_port   = 8088
    to_port     = 8088
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Spark UI"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Spark Master"
    from_port   = 7077
    to_port     = 7077
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Debezium"
    from_port   = 8083
    to_port     = 8083
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Airbyte"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Autoriser toutes les connexions sortantes
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

##############################
# 5️⃣ Création de l'instance EC2
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
  # 5a️. Copier docker-compose.yml
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
  # 5b️. Copier le fichier .env
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
  # 5c. Copier le fichier Dockerfile.spark
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
  # 5d. Copier le dossier trino/
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
  # 5e. Copier le dossier notebooks/
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
  # 5f. Installation Docker & Docker Compose + lancement containers
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

##############################
# 5️⃣ Installation Airbyte et récupération des credentials
##############################
resource "null_resource" "airbyte_setup" {
  depends_on = [aws_instance.ec2]

  provisioner "remote-exec" {
    inline = [
      "curl -LsfS https://get.airbyte.com | bash",
      "abctl local install --port 8000 --low-resource-mode --insecure-cookies",
      "abctl local credentials --json > /home/ec2-user/airbyte_credentials.json"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/${var.key_name}")
      host        = aws_instance.ec2.public_ip
    }
  }

  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -i ~/.ssh/${var.key_name} ec2-user@${aws_instance.ec2.public_ip}:/home/ec2-user/airbyte_credentials.json ./airbyte_credentials.json"
  }
}
