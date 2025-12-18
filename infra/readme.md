# README – Déploiement Infrastructure AWS avec Terraform & Docker Compose

Ce projet permet de déployer une instance **EC2** sur AWS avec **Docker** installé pour exécuter un stack via `docker-compose` (incluant un lakehouse Iceberg avec Rest Catalog).

## 1️⃣ Prérequis

- Compte AWS actif
- **AWS CLI** installé
- **Terraform** installé (v1.0+)
- Clé SSH publique si vous voulez vous connecter en SSH à l’instance

## 2️⃣ Création d’un utilisateur IAM pour Terraform

1. Connectez-vous à la console **AWS** → **IAM** → **Users** → **Add users**
2. Nom de l’utilisateur : `terraform-user`
3. Type d’accès : **Access key - Programmatic access**
4. Permissions : **AmazonEC2FullAccess**
5. Récupérez et notez :
   - **AWS Access Key ID**
   - **AWS Secret Access Key**

## 3️⃣ Configuration des credentials AWS
Installez l’AWS CLI si nécessaire :
```bash
# macOS
brew install awscli
# sinon 
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
# Ubuntu/Debian
sudo apt-get install awscli
```

Configurez : 
```bash
aws configure
```

Renseignez :
```bash
AWS Access Key ID [None]: <VOTRE_CLE_ID>
AWS Secret Access Key [None]: <VOTRE_CLE_SECRETE>
Default region name [None]: eu-west-3
Default output format [None]: json
```

## 4️⃣ Variables Terraform

Lors de l’exécution, vous pouvez passer :

- key_name : Nom de la key pair AWS existante

- docker_compose_path : Chemin vers votre fichier docker-compose.yml

- allowed_cidr : Adresse IP autorisée à se connecter en SSH (ex: 82.65.77.174/32)

Création d'une clé 
```bash
#Linux
ssh-keygen -t rsa -b 4096 -f ~/.ssh/demo
#Windows
ssh-keygen -t rsa -b 4096 -f "$env:USERPROFILE\.ssh\demo"
```

5️⃣ Déploiement
```bash
terraform init
terraform plan -var "key_name=demo" -var "allowed_cidr=MON.IP/32"
terraform apply -auto-approve -var "key_name=demo" -var "allowed_cidr=MON.IP/32"
```

6️⃣ Connexion à l’instance
```bash
#Linux
ssh -i ~/.ssh/<votre-cle-privee>.pem ec2-user@<public-ip-ec2>

#Windows
ssh -i "$env:USERPROFILE\.ssh\demo" ec2-user@<public-ip-ec2>
```

7️⃣ Arrêt et destruction
Pour libérer les ressources AWS :

```bash
terraform destroy -auto-approve var "key_name=demo" -var "allowed_cidr=MON.IP/32"
```