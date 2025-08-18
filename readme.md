# Lakehouse Project

## 🌟 Objectif du projet

Ce projet met en place un **Lakehouse** complet pour le traitement et l'analyse de données à grande échelle, en utilisant :  

- **Apache Spark** pour le traitement distribué.  
- **Apache Iceberg** comme format de table transactionnel sur le lac de données.  
- **Trino** pour les requêtes SQL interactives sur les données.  
- **Apache Superset** pour la visualisation et le reporting BI.  
- **Terraform** pour provisionner l’infrastructure sur AWS.  
- **MinIO** comme stockage S3 compatible local/cloud.  
- **Docker & Docker Compose** pour orchestrer facilement les services.

L’objectif est de fournir un environnement **réproducible**, permettant de tester et déployer des pipelines data de manière modulaire et scalable.

---

## 🏗 Architecture générale

Voici un schéma simplifié de l’architecture :

     +-------------------+
     |  Jupyter Notebook |
     +---------+---------+
               |
               v
     +-------------------+
     |       Spark       |
     | (Docker / Custom)|
     +---------+---------+
               |
               v
     +-------------------+
     |      Iceberg      |
     |     (Tables)      |
     +---------+---------+
               |
               v
     +-------------------+
     |       Trino       |
     |  (Query Engine)   |
     +-------------------+

               |
               v
     +-------------------+
     |      Superset     |
     |     (Dashboard)   |
     +-------------------+

     +-------------------+
     |       MinIO       |
     | (S3 Storage)      |
     +-------------------+



---

## ⚙️ Prérequis
- **Docker** et **Docker Compose**
- **Terraform** ≥ 1.5
- **AWS CLI** configuré avec un profil ayant accès à VPC, EC2 et Security Groups
- **Python 3.10+** pour les notebooks

---

## 🚀 Installation et lancement

1. **Déployer l’infrastructure :**
```bash
terraform init
terraform apply
```

2. **Démarrer les services Docker localement :**

```bash
docker-compose up -d
```

## Si tu as déjà importé ta key et que tu as cette erreur : 
```bash
InvalidKeyPair.Duplicate: The keypair already exists
```

Fais ça puis relance le terraform apply

```bash
aws ec2 delete-key-pair --key-name demo
terraform import aws_key_pair.default demo
```



3. **Accéder à Jupyter Notebook :**

- http://localhost:8888 (Le mot de passe est défini dans le Dockerfile)

## 📚 **Utilisation**

Les notebooks Spark se trouvent dans notebooks/ :

Spark.ipynb : introduction et tests Spark

SparkSQL.ipynb : exemples SQL sur Iceberg via Spark

Les configurations Trino et Iceberg sont dans trino/.

Les ressources Terraform dans infra/.

🔒 Sécurité

Les Security Groups AWS sont configurés pour exposer uniquement les ports nécessaires :

![Alt text](docs/map.jpg?raw=true "Title")

Les fichiers sensibles comme *.pem, *.tfvars sont exclus du dépôt via .gitignore.

## 📈 **Avantages**

- Environnement reproductible pour tests et développement.
- Possibilité de scaler Spark et Trino facilement.
- Isolation complète grâce aux conteneurs Docker.
- Compatible avec AWS et stockage S3 local via MinIO.

## 📎 **Quick Reference Commands**
-------------------------------

| **Component** | **Command** |
| --- | --- |
| **Start Services** | `docker-compose up --build -d` |
| **Stop Services** | `docker-compose down` |
| **View Running Containers** | `docker ps` |
| **Check Logs** | `docker-compose logs -f` |
| **Rebuild Containers** | `docker-compose up --build --force-recreate -d` |

* * * * *