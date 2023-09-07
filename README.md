# IGWN Rucio Initialisation

Deployment specs to initialise a Rucio deployment.  Based on https://github.com/tbeerman/rucio-k8s-tutorial.

Basic procedure

## Deploy and initialise backend database: single-tier

Deploy postgres from Helm:

    $  helm install postgres bitnami/postgresql -f postgres_values.yaml

Run the Rucio init container to bootstrap the database:

    $ kubectl apply -f init-pod.yaml

Check things look ok:

    $  k exec -it postgres-postgresql-0 -- bash
    I have no name!@postgres-postgresql-0:/$ psql -U rucio rucio
    Password for user rucio:
    psql (12.8)
    Type "help" for help.

    rucio=> set search_path=test;
    SET
    rucio=> \dt;
                       List of relations
     Schema |             Name             | Type  | Owner
    --------+------------------------------+-------+-------
     test   | account_attr_map             | table | rucio
     test   | account_glob_limits          | table | rucio

## Deploy and initialise backend database: multi-tier (HA)

Deploy bitnami postgres-ha chart from Helm:

     $  helm install rucio-db bitnami/postgresql-ha -f postgres-ha_values.yaml

Run the Rucio init container to bootstrap the database:

    $ kubectl apply -f init-pod.yaml

Note that we point at the pgpool pod:

    postgresql://rucio:secret@rucio-db-postgresql-ha-pgpool/rucio

Check things look ok by spinning up a postgres client and checking tables:

    $ kubectl run postgresql-postgresql-client \
      --rm --tty -i --restart='Never' --namespace ligo-rucio \
      --image bitnami/postgresql --env="PGPASSWORD=secret" \
      --command -- psql --host rucio-db-postgresql-ha-pgpool -U rucio

    $  ./postgres-client 
    If you don't see a command prompt, try pressing enter.

    rucio=> \dt;
                List of relations
     Schema |      Name       | Type  | Owner 
    --------+-----------------+-------+-------
     public | alembic_version | table | rucio
    (1 row)

    rucio=> set search_path='test';
    SET
    rucio=> \d;t
    Invalid command \d;t. Try \? for help.
    rucio=> \dt;
                       List of relations
     Schema |             Name             | Type  | Owner 
    --------+------------------------------+-------+-------
     test   | account_attr_map             | table | rucio
     test   | account_glob_limits          | table | rucio
     test   | account_limits               | table | rucio
     test   | account_map                  | table | rucio

Note that the `test` schema is created by `init-pod.yaml`:

         - name: RUCIO_CFG_DATABASE_SCHEMA
           value: test


## Certificate Secrets

Generate certificate secrets with the secretGenerator in the kustomization file:

    $  kubectl apply -k .

**Note**: make sure the release name prefix for the secrets matches what you'll use with Helm.

## Deploy rucio server

Clone the IGWN branch from the mirror of the helm charts:

    $  git clone --branch igwn git@git.ligo.org:rucio/helm-charts.git

Deploy with Helm:

    $  helm install rucio-server helm-charts/charts/rucio-server

### Initial X509 proxy

The Rucio server helm deployment will not start until the FTS proxy cronjob has
run.  To avoid waiting, execute:

    $  kubectl create job renew-manual-1 --from=cronjob/<release-name>-renew-fts-proxy

## Deploy rucio daemons

Deploy with Helm:

    $  helm install rucio-daemons helm-charts/charts/rucio-daemons

### Initial X509 proxy

As with the server, the Rucio daemons helm deployment will not start until the
FTS proxy cronjob has run.  To avoid waiting, execute:

    $  kubectl create job renew-manual-1 --from=cronjob/<release-name>-renew-fts-proxy

## Account creation

TODO: the initial bootstrapped identities should be updated.
