EXPERIMENTAL
============

This devcontainer is intended for use on DLS RHEL8 workstations for 
python3 development.

Supported Workflows
-------------------

- DLS Python3 pipenv workflow
  - via the mounted dls_sw tools directory 
    i.e. /dls_sw/prod/tools/RHEL7-x86_64/defaults/bin/pipenv
  - NOTE: to create a virtual environment for this workflow:
    - `pipenv install --python dls-python3`
- python3-pip-skeleton workflow
  - via python 3.10 installed into this container
  - NOTE: to create a virtual environment for this workflow:
    - `/usr/local/py-utils/bin/virtualenv .venv`

Workflows NOT Supported
-----------------------

- DLS C++ compilation and execution of EPICS IOCs
  - because it does not have all of the system library dependencies

For EPICS development instead see https://dls-controls.github.io/dev-c7

It is not possible to support all the above in a single container
because dev-c7 is based on centos 7 and vscode now only supports 
devcontainers that are debian based.
