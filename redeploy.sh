#!/bin/bash

export RUCIO_DB_PASS='sense-rucio'

# Remove all previous deployment artifacts.
helm -n ucsd-rucio uninstall rucio-server 
helm -n ucsd-rucio uninstall rucio-daemons
helm -n ucsd-rucio uninstall rucio-db 

kubectl -n ucsd-rucio delete job rucio-server-renew-fts-proxy-on-helm-install
kubectl -n ucsd-rucio delete job rucio-daemons-renew-fts-proxy-on-helm-install
# kubectl -n ucsd-rucio delete secret rucio-daemons-rucio-x509up
# kubectl -n ucsd-rucio delete secret rucio-server-rucio-x509up

# Deploy Database
./helm_install_postgres
sleep 10
kubectl -n ucsd-rucio apply -f init-db-schema-job.yaml
# Deploy Rucio
sleep 50
./helm_install_server &
./helm_install_daemons
