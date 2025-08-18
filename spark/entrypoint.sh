#!/bin/bash
# Démarrer Spark Master
/opt/bitnami/spark/sbin/start-master.sh --host 0.0.0.0 &

# Lancer Jupyter Notebook
jupyter notebook --ip=0.0.0.0 --no-browser --allow-root --NotebookApp.token='' --NotebookApp.password=''

# Garder le conteneur vivant (optionnel si Jupyter reste au premier plan)
tail -f /dev/null