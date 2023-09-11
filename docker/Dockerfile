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

COPY /CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo

RUN yum update -y && \
   yum groupinstall -y "Development Tools" && \
   yum install -y \
     sudo \
     environment-modules \
     perl-core \
     glibc.i686 \
     gcc \
     gcc-c++ \
     readline.i686 \
     readline.x86_64 \
     compat-readline5.i686 \
     compat-readline5.x86_64 \
     perl-core-5.10.1-144.el6.x86_64 \
     perl-core \
     glibc.i686 \
     glibc.i686 \
     gcc \
     gcc-c++ \
     readline.i686 \
     readline.x86_64 \
     compat-readline5.i686 \
     compat-readline5.x86_64 \
     compat-gcc-34 \
     compat-gcc-34-c++ \
     compat-glibc \
     compat-glibc-headers \
     readline-devel \
     java-1.8.0-openjdk-devel && \
   yum clean all && \
   rm -fr /var/lib/yum/yumdb/*

# full sudo rights inside the container
COPY /sudoers /etc/sudoers
# set container time to BST
RUN ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime

# change the nobody account and group IDs to match RedHat
RUN sed -i 's/99:99/65534:65534/' /etc/passwd && \
    sed -i 's/:99:/:65534:/' /etc/group
