# Dockerfile for getting DLS RHEL6 dev environment working in a container
# hosted on RHEL8
#
# This is a stopgap so that we can use effort to promote the
# kubernetes model https://github.com/dls-controls instead of spending
# effort in rebuilding our toolchain for RHEL8

FROM centos:6

# environment
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LC_CTYPE=en_US.UTF-8

# full sudo rights inside the container
COPY /sudoers /etc/sudoers

# set container time to BST
RUN ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime

# change the nobody account and group IDs to match RedHat
RUN sed -i 's/99:99/65534:65534/' /etc/passwd && \
    sed -i 's/:99:/:65534:/' /etc/group
