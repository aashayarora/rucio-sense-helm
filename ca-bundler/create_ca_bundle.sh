#!/bin/bash

if [ -z ${CA_BUNDLE_SECRET_NAME} ]; then
  echo CA_BUNDLE_SECRET_NAME not set, trying from command line
  CA_BUNDLE_SECRET_NAME=${1}
fi

CERTS_DIR=/etc/grid-security/certificates

# Copy certs with resolved symlinks
echo "Resolving symlinked CA certs"
cp -rL ${CERTS_DIR} /tmp/certs

# Create / update secret
echo "Creating secret: ${CA_BUNDLE_SECRET_NAME}"

kubectl get secret ${CA_BUNDLE_SECRET_NAME} &> /dev/null && \
  kubectl delete secret ${CA_BUNDLE_SECRET_NAME} #  too much metadata for kubectl apply

kubectl create secret generic ${CA_BUNDLE_SECRET_NAME} --from-file=/tmp/certs
