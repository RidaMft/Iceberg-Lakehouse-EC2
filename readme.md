# 🏞️ Lakehouse Project

## 🌟 Objectif

Ce projet met en place un **Lakehouse** complet pour le traitement et l’analyse de données à grande échelle, en combinant :

- ⚡ **Apache Spark** : traitement distribué  
- 🧊 **Apache Iceberg** : format de table transactionnel  
- 🔍 **Trino** : moteur SQL interactif  
- 📊 **Apache Superset** : visualisation et reporting BI  
- 🧠 **OpenMetadata** : gouvernance des métadonnées  
- 🔄 **Airbyte** : ingestion de données automatisée  
- 🧪 **dbeaver** : interface SQL web interactive  
- ☁️ **MinIO** : stockage S3 compatible  
- 🐳 **Docker & Docker Compose** : orchestration locale  
- 🌐 **Terraform** : provisionnement AWS  

🎯 L’objectif est de fournir un environnement **modulaire, scalable et reproductible** pour tester et déployer des pipelines data.

---

## 🏗️ Architecture

```text
+-------------------+       +-------------------+
| Jupyter Notebook  | <-->  |      Spark        |
+-------------------+       +-------------------+
                                        |
                                        v
                                +-------------------+
                                |     Iceberg       |
                                +-------------------+
                                        |
                                        v
                                +-------------------+         +-------------------+
                                |      Trino        |  <-->   |        dbeaver        |
                                +-------------------+         +-------------------+
                                        |
                                        v
                                +-------------------+         +-------------------+
                                |     Superset      |         |   OpenMetadata    |
                                +-------------------+         +-------------------+

+-------------------+         +-------------------+
|      MinIO        |         |      Airbyte      |
+-------------------+         +-------------------+
```

---

## ⚙️ Prérequis

- Docker & Docker Compose  
- Terraform ≥ 1.5  
- AWS CLI configuré  
- Python ≥ 3.10  

---

## 🚀 Installation

### 1. Déploiement de l’infrastructure AWS

```bash
terraform init
terraform apply
```

💡 Si tu rencontres l’erreur suivante :
```bash
InvalidKeyPair.Duplicate: The keypair already exists
```
Exécute :

```bash
aws ec2 delete-key-pair --key-name demo
terraform import aws_key_pair.default demo
```

---

### 2. Lancement des services Docker

```bash
docker-compose \
        -f docker-compose.yaml \
        -f docker-compose.superset.yaml \
        -f docker-compose.openmetadata.yaml \
        -f docker-compose.dbeaver.yaml \
        up -d
```

---

### 3. Accès aux interfaces

| Interface         | URL                          | Identifiants par défaut     |
|-------------------|------------------------------|-----------------------------|
| 📓 Jupyter         | http://localhost:8888        | -                           |
| 🔍 Trino UI        | http://localhost:8080        | `trino`                          |
| 📊 Superset        | http://localhost:8088        | `admin` / `admin`           |
| 🧪 DbEaver         | http://localhost:8881        | -                           |
| 🧠 OpenMetadata    | http://localhost:8585        | `admin@open-metadata.org` / `admin`           |
| 🔄 Airbyte         | http://localhost:8000        | -                           |
| ☁️ MinIO Console   | http://localhost:9001        | `minio` / `minio123` |

> Remplace `localhost` par l’IP publique de ton serveur si tu déploies à distance.

---

## 📚 Utilisation

### 🔬 Notebooks

- `notebooks/SparkSQL.ipynb` : requêtes SQL sur Iceberg  

### ⚙️ Configuration

- `trino/iceberg.properties` : config Trino  
- `infra/` : ressources Terraform  
- `superset/` : configuration Superset (optionnelle)  

### 🔗 Connexion Superset

- **SQLAlchemy URI** :

```bash
trino://trino@trino:8080/iceberg/
```

- **Ajout dans Superset** :
  1. Ouvre http://localhost:8088  
  2. Va dans **Data → Databases → +**  
  3. Colle l’URI ci-dessus  

---

## 🔒 Sécurité

- Les **Security Groups AWS** exposent uniquement les ports nécessaires.  
- Les fichiers sensibles (`*.pem`, `*.tfvars`) sont exclus via `.gitignore`.

---

## 📈 Avantages

- Environnement reproductible  
- Scalable avec Spark & Trino  
- Visualisation et gouvernance intégrées  
- Compatible AWS & S3 local  
- Intégration de données automatisée  

---

## 📎 Commandes utiles

| 📦 Composant        | 🛠️ Commande                                      |
|---------------------|--------------------------------------------------|
| Démarrer les services | `docker-compose up --build -d`                |
| Arrêter les services  | `docker-compose down`                         |
| Voir les conteneurs   | `docker ps`                                   |
| Logs en direct        | `docker-compose logs -f`                      |
| Rebuild complet       | `docker-compose up --build --force-recreate -d` |

---

## 🛠️ Fonctionnalités à venir

- ⚙️ **Apache Flink + Debezium** : ingestion de données en temps réel via CDC  
- 🧬 **DBT (Data Build Tool)** : transformations SQL et documentation des modèles  
- 🔐 **Authentification centralisée** : via OAuth2 / Keycloak  
- 📡 **Monitoring** : intégration de Grafana + Prometheus  
