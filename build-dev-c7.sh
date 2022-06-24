#!/bin/bash

name=ghcr.io/dls-controls/dev-c7

set -e
podman build\
    --network host \
    -t ${name}:latest \
    ./docker


# read -r -p "dev-c7 built OK. Push to ${name}:${1} [y/N] " response
# response=${response,,}    # tolower
# if [[ "$response" =~ ^(yes|y)$ ]] ; then
#     podman tag ${name}:latest ${name}:${1}
#     podman push ${name}:latest
#     podman push ${name}:${1}
# fi
