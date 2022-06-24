VSCode integration
==================

.. note::

    This feature has been removed from ``dev-c7``.
    Unfortunately vscode has recently restricted devcontainers to require that 
    they are derived from a Debian based image. For this reason the dev-c7
    container is not compatible as it is required to be based on Centos 7. 

VSCode has beautiful integration for developing in containers. See here
https://code.visualstudio.com/docs/remote/containers for a detailed 
description of this feature. 

Although the tight integration is no longer supported for ``dev-c7`` it is still 
possible to use VSCode and start the ``dev-c7`` container in each of its 
integrated terminals.

If you work in this way, you will not be able to directly use the 
vscode C++ debugger or launch unit tests from the test explorer. 
However, approaches to restore
these features are under investigation!


Python Development
------------------

I have provided an **experimental** devcontainer in the repo that allows 
developers to use the full suite of VSCode integration features for 
developing:

- DLS Python 3 pipenv based workflow with dls-python3
- python3-pip-skeleton based workflow with python3.10

Note that to make vscode devcontainers work with python requires the plugin 
``ms-vscode-remote.vscode-remote-extensionpack`` and the
following setting in 
``$HOME/.config/Code/User/settings.json``::

    "remote.containers.dockerPath": "podman"

See the notes here: 
https://github.com/dls-controls/dev-c7/blob/dev/.devcontainer