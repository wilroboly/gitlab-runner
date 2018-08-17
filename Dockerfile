FROM gitlab/gitlab-runner:latest
LABEL maintainer William Roboly (wilco@nurf.com)

USER root

# Please have a PEM file or ca-bundle stored in this location
RUN apt-get update
# RUN apt-get install ca-certificates
# RUN ln -s /etc/certs/cbs/Certificates.pem /usr/local/share/ca-certificates/cacerts.crt
# RUN /usr/sbin/update-ca-certificates
#
# # Install packages
# RUN apk add --no-cache --update gcc g++ nodejs python openssh-client
#
# # Install node packages
# RUN npm install --global gulp gulp-cli grunt webpack yarn bower sass
#
# # Setup for ssh onto gitlab.com
# ADD ./ssh-keys/id_rsa /home/wodby/.ssh/id_rsa
# RUN chmod 700 /home/wodby/.ssh/id_rsa
# RUN chown wodby:wodby /home/wodby/.ssh/id_rsa
# RUN ssh-keyscan gitlab.com > /home/wodby/.ssh/known_hosts
