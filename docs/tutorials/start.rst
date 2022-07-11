Quick Start
===========

Setup
-----

First, if you have never used containers at DLS before, then you must 
do an initial podman setup::

    /dls_sw/apps/setup-podman/setup.sh

.. warning::

    If you have previously used podman you may need to perform a migration.
    See `../how-to/podman`

Second, in order to support secondary groups we require the crun container 
runtime. This should be installed by default but early adopters
will need::

    sudo yum install crun

Startup Script run-dev-c7.sh
----------------------------

Next, copy the startup script to your local bin directory and make it 
executable::

    cd $HOME/bin
    wget -nc https://github.com/dls-controls/dev-c7/releases/download/2.0.0/run-dev-c7.sh
    chmod +x run-dev-c7.sh

The above gets version 2.0.0 which is current as of 01/07/2022.
See https://github.com/dls-controls/dev-c7/releases for the latest updates.

Finally, launch an instance of the container by typing::

    run-dev-c7.sh

.. note::
    For the first invocation of an updated version of the container there 
    will be a 30 second delay while the filesystem user id namespace mapping 
    is cached.

How to Work
-----------

At a dev-c7 prompt you can work normally as if you were sitting at a RHEL7 
workstation. Everything should work as before although there are a few 
differences, see
`../explanations/differences`. 

If you find anything that does not work or have suggestions for improvement,
please report it 
`On GitHub Issues <https://github.com/dls-controls/dev-c7/issues>`_.

- You can launch multiple instances of dev-c7 and they will share the
  same container. 
- You can run gnome-terminal and open multiple tabs - all will be in the 
  container
- You can use module load as usual to make further software from dls_sw
  available
- You can run GUI apps as normal.
- You have full sudo rights and can install anything you need into the
  container with ``yum install``
- Do NOT run vscode inside the container. Instead run it normally and 
  feel free to launch dev-c7 inside of its integrated terminals to do 
  compilation, testing.
