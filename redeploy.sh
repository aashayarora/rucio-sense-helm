#!/bin/bash

helm uninstall rucio-server && helm uninstall rucio-daemons && helm uninstall rucio-db 
kubectl delete pvc data-rucio-db-postgresql-0

./helm_install_postgres
sleep 30
kubectl apply -f init-db-schema-job.yaml
sleep 30
./helm_install_server && ./helm_install_daemons
