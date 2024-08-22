#!/bin/bash

export RUCIO_DB_PASS='sense-rucio'

# Remove all previous deployment artifacts.
helm uninstall rucio-server 
helm uninstall rucio-daemons
helm uninstall rucio-db 

kubectl delete job rucio-server-renew-fts-proxy-on-helm-install
kubectl delete job rucio-daemons-renew-fts-proxy-on-helm-install
kubectl delete secret rucio-daemons-rucio-x509up
kubectl delete secret rucio-server-rucio-x509up

# Deploy Database
./helm_install_postgres
kubectl apply -f init-db-schema-job.yaml
# Deploy Rucio
sleep 50
./helm_install_server &
./helm_install_daemons &