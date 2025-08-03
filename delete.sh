export RUCIO_DB_PASS='sense-rucio'

# Remove all previous deployment artifacts.
helm -n ucsd-rucio uninstall rucio-server
helm -n ucsd-rucio uninstall rucio-daemons
helm -n ucsd-rucio uninstall rucio-db

kubectl -n ucsd-rucio delete job rucio-server-renew-fts-proxy-on-helm-install
kubectl -n ucsd-rucio delete job rucio-daemons-renew-fts-proxy-on-helm-install
# kubectl -n ucsd-rucio delete secret rucio-daemons-rucio-x509up
# kubectl -n ucsd-rucio delete secret rucio-server-rucio-x509up
