FROM gitlab/gitlab-runner:latest
LABEL maintainer William Roboly (wilco@nurf.com)

USER root

# Please have a PEM file or ca-bundle stored in this location
RUN apt-get update

# https://docs.gitlab.com/runner/configuration/tls-self-signed.html#supported-options-for-self-signed-certificates

# If the address of your server is: `https://my.gitlab.server.com:8443/`.
# Create the certificate file at: `/etc/gitlab-runner/certs/my.gitlab.server.com.crt`.

