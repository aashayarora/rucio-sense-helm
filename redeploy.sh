#!/bin/bash

# Remove all previous deployment artifacts.
helm uninstall rucio-server && helm uninstall rucio-daemons && helm uninstall rucio-db 
kubectl delete job rucio-server-renew-fts-proxy-on-helm-install
kubectl delete job rucio-daemons-renew-fts-proxy-on-helm-install

# Deploy Database
./helm_install_postgres
sleep 30
kubectl apply -f init-db-schema-job.yaml
sleep 30
./helm_install_server &
./helm_install_daemons &
