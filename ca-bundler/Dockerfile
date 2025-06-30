FROM almalinux:9

# OSG CA bundle
RUN rpm -Uvh https://repo.opensciencegrid.org/osg/3.6/osg-3.6-el9-release-latest.rpm &&\
      yum install -y epel-release osg-ca-certs && \
      yum install -y fetch-crl && \
      yum clean all && \
      rm -rf /var/cache/yum

# Install latest kubectl
RUN curl -o /usr/bin/kubectl -L https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x /usr/bin/kubectl

COPY create_ca_bundle.sh /create_ca_bundle.sh
COPY docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
