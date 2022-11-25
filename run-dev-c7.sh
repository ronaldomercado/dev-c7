#!/bin/bash

# A script for launching 'RHEL 7 in a Box' on a DLS workstation

# NOTE that changes to this file should also be propgated to .devcontainer.json

image=ghcr.io/dls-controls/dev-c7
version=latest
hostname=$(hostname)
changed=false
pull=false
rhel=8
delete=false
install_devcontainer_json=false
network="--net=host"
userns="--userns=keep-id"
logging=""
# -l loads profile and bashrc
command="/bin/bash -l"
commandargs=

while getopts "lrdphs:i:v:cnI" arg; do
    case $arg in
    l)  logging="set -x"    # enable logging
        ;;
    r)
        changed=true
        userns=""
        ;;
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
    n)
        network="--network=podman"
        changed=true
        ;;
    v)
        version=$OPTARG
        changed=true
        ;;
    c)
        commandargs=YES
        command="/bin/bash -lc "
        break
        ;;
    d)  delete=true
        ;;
    I)  install_devcontainer_json=true
        ;;
    *)
        echo "
usage: run-dev-c7.sh [options]

Launches a developer container that simulates a DLS RHEL7 workstation.

Options:

    -l              Enable logging
    -h              show this help
    -r              run as root
    -p              pull an updated version of the image first
    -i image        specify the container image (default: "${image}")
    -v version      specify the image version (default: "${version}")
    -s host         set a hostname for your container (default: ${hostname})
    -d              delete previous container and start afresh
    -n              run in podman virtual network instead of the host network
    -c command      run a command in the container (must be last option)
    -I              Install .devcontainer/devcontainer.json in the current directory for vscode
"
        exit 0
        ;;
    esac
done

shift $((OPTIND-1))

if [[ ${install_devcontainer_json} == true ]] ; then
    mkdir -p .devcontainer
    cd .devcontainer
    wget -q https://github.com/dls-controls/dev-c7/releases/download/${version}/devcontainer.json
    echo "Installed devcontainer.json. Try 'Reopen in Container' or 'Reload Window'."
    exit 0
fi

if ! grep overlay ~/.config/containers/storage.conf &> /dev/null; then
    echo "ERROR: dev-c7 requires overlay filesystem."
    echo "Please see https://dls-controls.github.io/dev-c7/main/how-to/podman.html"
    exit 1
fi

if [[ -e /etc/centos-release ]] ; then
    echo "ERROR: already in the a devcontainer"
    exit 1
fi

if ${delete} ; then
    podman rm -ft0 dev-c7
    changed=false
fi

if [[ $(podman version -f {{.Version}}) == 1.* ]] ; then
    echo "WARNING: this is a RHEL7 machine - EXPERIMENTAL SUPPORT ONLY"
    echo "
WARNING: You will run as root in the container and will not be able to
use group permissions
"
    rhel=7
fi

environ="-e DISPLAY -e HOME -e USER -e SSH_AUTH_SOCK"
volumes="
    -v /dls_sw/prod:/dls_sw/prod
    -v /dls_sw/work:/dls_sw/work
    -v /dls_sw/epics:/dls_sw/epics
    -v /dls_sw/targetOS:/dls_sw/targetOS
    -v /dls_sw/apps:/dls_sw/apps
    -v /dls_sw/etc:/dls_sw/etc
    -v /scratch:/scratch
    -v /home:/home
    -v /dls/science:/dls/science
    -v /run/user/$(id -u):/run/user/$(id -u)
"

devices="-v /dev/ttyS0:/dev/ttyS0"
opts="${network} --hostname ${hostname}"

# the identity settings enable secondary groups in the container
if [[ ${rhel} == 8 ]] ; then
    identity="--security-opt=label=type:container_runtime_t ${userns}
              --annotation run.oci.keep_original_groups=1"
    volumes="${volumes} -v /tmp:/tmp"
fi

# this runtime is also required for secondary groups
if which crun &> /dev/null ; then
    runtime="--runtime /usr/bin/crun"
    identity="${identity} --storage-opt ignore_chown_errors=true"
fi

container_name=dev-c7

################################################################################
# Start the container in the background and then launch an interactive bash
# session in the container. This means that all invocations of this script
# share the same container. Also changes to the container filesystem are
# preserved unless an explict 'podman rm dev-c7' is invoked.
################################################################################

running=false

if [[ -n $(podman ps -q -f name=${container_name}) ]]; then
    # container already running so no prep required
    if ${changed} ; then
        echo "ERROR: cannot change properties on a running container."
        echo "Use -d option to delete the current container."
        exit 1
    fi
    running=true
    echo "attaching to existing dev-c7 container ${version} ..."
elif [[ -n $(podman ps -qa -f name=${container_name}) ]]; then
    # start the stopped container
    echo "deleting stopped dev-c7 container ..."

    podman rm ${container_name}
fi

if [[ ${running} == "false" ]]; then
    # check for updates if requested
    if ${pull} ; then
        podman pull ${image}:${version}; echo
    fi

    # create a new background container making process 1 be 'sleep'
    # prior to sleep we update the default shell to be bash
    # this is because podman adds a user in etc/passwd but fails to honor
    # /etc/adduser.conf
    echo "creating new dev-c7 container ${version} ..."
    ${logging}
    podman run -dit --name ${container_name} ${runtime} ${environ}\
        ${identity} ${volumes} ${devices} ${opts} ${image}:${version} \
        bash -c "sudo sed -i s#/bin/sh#/bin/bash# /etc/passwd ; bash"
fi

# Execute a shell in the container - this allows multiple shells and avoids
# using process 1 so users can exit the shell without killing the container
if [[ -n ${commandargs} ]] ; then
    ${logging}
    podman exec -itw $(pwd) ${container_name} ${command} "$*"
else
    ${logging}
    podman exec -itw $(pwd) ${container_name} ${command}
fi
