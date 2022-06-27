#!/bin/bash

# A script for launching 'RHEL 7 in a Box' on a DLS workstation

# NOTE that changes to this file should also be propgated to .devcontainer.json

image=ghcr.io/dls-controls/dev-c7
version=latest
hostname=dev-c7
changed=false
pull=false
rhel=8

while getopts "phs:i:v:" arg; do
    case $arg in
    p)  
        pull=true
        changed=true
        ;;
    s)
        hostname=$OPTARG
        changed=true
        ;;
    i)
        image=$OPTARG
        changed=true
        ;;
    v)
        version=$OPTARG
        changed=true
        ;;
    *)
        echo "
usage: run-dev-c7.sh [options]

Launches a developer container that simulates a DLS RHEL7 workstation.

Options:

    -h              show this help    
    -p              pull an updated version of the image first   
    -i image        specify the container image (default: "${image}")
    -v version      specify the image version (default: "${version}")
    -s host         set a hostname for your container (default: ${hostname})
"
        exit 0
        ;;
    esac
done


if [[ -e /etc/centos-release ]] ; then
    echo "ERROR: already in the a devcontainer"
    exit 1
fi

if [[ $(podman version -f {{.Version}}) == 1.* ]] ; then
    echo "WARNING: this is a RHEL7 machine - EXPERIMENTAL SUPPORT ONLY"
    echo "
WARNING: You will run as root in the container and will not be able to 
use group permissions
"
    rhel=7
fi 


environ="-e DISPLAY -e HOME -e USER"
volumes=" 
    -v /dls_sw/prod:/dls_sw/prod
    -v /dls_sw/work:/dls_sw/work
    -v /dls_sw/epics:/dls_sw/epics
    -v /dls_sw/targetOS/vxWorks/Tornado-2.2:/dls_sw/targetOS/vxWorks/Tornado-2.2
    -v /dls_sw/apps:/dls_sw/apps
    -v /dls_sw/etc:/dls_sw/etc
    -v /scratch:/scratch
    -v /home:/home
    -v /dls/science/users/:/dls/science/users/
"

devices="-v /dev/ttyS0:/dev/ttyS0"
opts="--net=host --hostname ${hostname}"

# the identity settings enable secondary groups in the container
if [[ ${rhel} == 8 ]] ; then
    identity="--security-opt=label=type:container_runtime_t --userns=keep-id
              --annotation run.oci.keep_original_groups=1"
    volumes="${volumes} -v /tmp:/tmp"
fi

# this runtime is also required for secondary groups
if which crun &> /dev/null ; then 
    runtime="--runtime /usr/bin/crun"
    identity="${identity} --storage-opt ignore_chown_errors=true"
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

if [[ -n $(podman ps -q -f name=${container_name}) ]]; then
    # container already running so no prep required   
    if ${changed} ; then
        echo "ERROR: cannot change hostname or image on a running container."
        echo "Delete the container with 'podman rm -ft0 dev-c7' and retry."
        exit 1
    fi 
    echo 'attaching to exisitng dev-c7 container ...'
elif [[ -n $(podman ps -qa -f name=${container_name}) ]]; then
    # start the stopped container
    echo 'restarting stopped dev-c7 container ...'
    podman start ${container_name}
else
    # check for updates if requested
    if ${pull} ; then
        podman pull ${image}:${version}; echo
    fi

    # create a new background container making process 1 be 'sleep'
    # prior to sleep we update the default shell to be bash
    # this is because podman adds a user in etc/passwd but fails to honor
    # /etc/adduser.conf
    echo 'creating new dev-c7 container ...'
    podman run -d --name ${container_name} ${runtime} ${environ}\
        ${identity} ${volumes} ${devices} ${opts} ${image}:${version} \
        bash -c "sudo sed -i s#/bin/sh#/bin/bash# /etc/passwd ; sleep 1000d"
fi
# Execute a shell in the container - this allows multiple shells and avoids 
# using process 1 so users can exit the shell without killing the container
podman exec -itw $(pwd) ${container_name} ${command}
