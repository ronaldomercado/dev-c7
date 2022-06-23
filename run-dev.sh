#!/bin/bash

# A script for launching 'RHEL 7 in a Box' on a DLS workstation

# NOTE that changes to this file should also be propgated to .devcontainer.json

image=ghcr.io/dls-controls/dev-c7:latest

environ="-e DISPLAY -e HOME"
volumes="-v /dls_sw/prod:/dls_sw/prod \
        -v /dls_sw/work:/dls_sw/work \
        -v /dls_sw/epics:/dls_sw/epics \
        -v /dls_sw/targetOS/vxWorks/Tornado-2.2:/dls_sw/targetOS/vxWorks/Tornado-2.2 \
        -v /dls_sw/apps:/dls_sw/apps \
        -v /dls_sw/etc:/dls_sw/etc \
        -v /scratch:/scratch \
        -v ${HOME}:${HOME} \
        -v /dls/science/users/:/dls/science/users/"

devices="-v /dev/ttyS0:/dev/ttyS0"
opts="--net=host --hostname dev-c7"
# the identity settings enable secondary groups in the container
identity="--security-opt=label=type:container_runtime_t --userns=keep-id \
          --annotation run.oci.keep_original_groups=1 \
          --storage-opt ignore_chown_errors=true"

# this runtime is also required for secondary groups
if which crun > /dev/null ; then 
    runtime="--runtime /usr/bin/crun"
fi

# -l loads profile and bashrc
command="/bin/bash -l"

container_name=dev-c7

################################################################################
# Start the container in the background and then launch an interactive bash  
# session in the container. This means that all invocations of this script
# share the same container. Also changes to the container filesystem are
# preserved unless an explict 'podman rm dev-c7' is invoked.
################################################################################

if [ "$(podman ps -q -f name=${container_name})" ]; then
    : # container already running so no prep required
elif [ "$(podman ps -qa -f name=${container_name})" ]; then
    # start the stopped container
    podman start ${container_name}
else
    # create a new background container making process 1 be 'sleep'
    podman run -d --name ${container_name} ${runtime} ${environ}\
        ${identity} ${volumes} ${devices} ${opts} ${image} \
        sleep 100d
fi
# Execute a shell in the container - this allows multiple shells and avoids 
# using process 1 so users can exit the shell without killing the container
podman exec -it ${container_name} ${command}
