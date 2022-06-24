# a devcontainer for DLS python3 pipenv based development
FROM mcr.microsoft.com/vscode/devcontainers/python:0-3.10-bullseye as developer

USER root
ENV PATH=/root/.local/bin:$PATH
COPY /sudoers /etc/sudoers

WORKDIR /workspaces

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    locales \
    libc-dev-bin \
    libssl-dev \
    environment-modules \
    wget \
    && rm -rf /var/lib/apt/lists/*

# dls-python3 links older versions of some dynamic libraries
COPY libs/* /usr/lib/x86_64-linux-gnu/
COPY start.sh /

ENTRYPOINT [ "bash", "-l" ]
