FROM ghcr.io/dls-controls/dev-c7:latest

# dev tools and libraries
RUN yum update -y && \
    yum install -y my-package

ENV MY_VAR="useful info"

COPY /my-useful-file.sh /usr/bin