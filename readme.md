Voici une version restructurée et plus esthétique de ton `README.md`, avec une meilleure hiérarchisation, des icônes, des sections claires et une mise en page plus fluide :

# 🏞️ Lakehouse Project

## 🌟 Objectif

Ce projet met en place un **Lakehouse** complet pour le traitement et l’analyse de données à grande échelle, en combinant :

- ⚡ **Apache Spark** : traitement distribué
- 🧊 **Apache Iceberg** : format de table transactionnel
- 🔍 **Trino** : moteur SQL interactif
- 📊 **Apache Superset** : visualisation et reporting BI
- ☁️ **MinIO** : stockage S3 compatible
- 🐳 **Docker & Docker Compose** : orchestration locale
- 🌐 **Terraform** : provisionnement AWS

🎯 L’objectif est de fournir un environnement **modulaire, scalable et reproductible** pour tester et déployer des pipelines data.

---

## 🏗️ Architecture

```text
+-------------------+       +-------------------+
| Jupyter Notebook  | <---> |      Spark        |
+-------------------+       +-------------------+
                                  |
                                  v
                          +-------------------+
                          |     Iceberg       |
                          +-------------------+
                                  |
                                  v
                          +-------------------+
                          |      Trino        |
                          +-------------------+
                                  |
                                  v
                          +-------------------+
                          |     Superset      |
                          +-------------------+

+-------------------+
|      MinIO        |
+-------------------+
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

> 💡 Si tu rencontres l’erreur suivante :
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
docker-compose up -d
```

---

### 3. Accès aux interfaces

- 📓 **Jupyter Notebook** : http://localhost:8888
- 📊 **Superset Dashboard** : http://localhost:8088
  - **Username** : `admin`
  - **Password** : `admin`

---

## 📚 Utilisation

### 🔬 Notebooks

- `notebooks/Spark.ipynb` : introduction à Spark
- `notebooks/SparkSQL.ipynb` : requêtes SQL sur Iceberg

### ⚙️ Configuration

- `trino/iceberg.properties` : config Trino
- `infra/` : ressources Terraform

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

!Architecture réseau

---

## 📈 Avantages

- Environnement reproductible
- Scalable avec Spark & Trino
- Isolation via Docker
- Compatible AWS & S3 local

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