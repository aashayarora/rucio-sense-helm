#!/bin/bash

export RUCIO_DB_PASS='sense-rucio'

# Deploy Database
./helm_install_postgres
sleep 10
kubectl -n ucsd-rucio apply -f init-db-schema-job.yaml
# Deploy Rucio
sleep 50
./helm_install_server &
./helm_install_daemons
