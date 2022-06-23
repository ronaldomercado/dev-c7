VSCode integration
==================

VSCode has beautiful integration for developing in containers. See here
https://code.visualstudio.com/docs/remote/containers for a detailed 
description of this feature. 

To make devcontainers work with podman requires a few extra settings.

I believe this will only work on RHEL8. The earlier version of podman on RHEL7
does not have the correct API.

Convince vscode to use podman
-----------------------------

Add the following to  
/home/[YOUR USER NAME]/.config/Code/User/settings.json 
to make vscode use podman to launch devcontainers::

    "remote.containers.dockerPath": "podman"

These additional settings ensure that each terminal loads the bash (login) 
profile by default. 
The login profile includes essential setup for DLS developer environment::

    "terminal.integrated.defaultProfile.linux": "bash (login)",
    "terminal.integrated.profiles.linux": {
        "bash (login)": {
            "args": [
                "-l"
            ],
            "path": "bash"
        }
    }


Install the remote development plugin
-------------------------------------

Run up vscode and install the remote development plugin:

    module load vscode
    code

Inside vscode:
    
    Ctrl+P
    ext install ms-vscode-remote.vscode-remote-extensionpack

add container config to local repository
----------------------------------------

Finally drop the file ``.devcontainer.json``` from here
https://github.com/dls-controls/dev-c7/blob/main/.devcontainer.json
into the root folder of a project
and then open that folder with VSCode. You will be prompted to reopen the project
in a container.

Now all the terminals you open in vscode will be inside the container and 
all file browsing and launchers will also be in the container.


Caveat - User ID
----------------

Unfortunately run-dev.sh uses --userns=keep-id to give you your native user id
inside and outside of the container. With VSCode integration this starts the
container OK but fails when VSCode tries to exec a service in the container.
Therefore we drop this option in .devcontainer.json and you will run as root
inside the VSCode terminals. 

Running as root has minimal side affects, any interaction
with host filesystems will use your own ID (because podman runs in your user
ID). SSH keys will still work but to SSH to another machine you will need
to use the following:
```bash
ssh your_fed_id@machine_name
```

Advanced - enable the docker plugin
-----------------------------------

The docker plugin allows you to manage containers from the explorer in 
vscode. This requires access to the docker socket which podman does not have.
However you can make podman look like docker with the following steps.

The docker plugin is here https://code.visualstudio.com/docs/containers/overview

install podman-docker
~~~~~~~~~~~~~~~~~~~~~

Execute these commands::

    sudo yum install podman-docker
    systemctl --user enable --now podman.socket
    
edit user settings
~~~~~~~~~~~~~~~~~~

Add the following to  /home/[YOUR USER NAME]/.config/Code/User/settings.json::

    "docker.dockerodeOptions": {
        "socketPath": "/run/user/[YOUR USER ID]/podman/podman.sock"
    },

(you can find your uid with the `id` command)
