Quick Start
===========

Setup
-----

First, if you have never used containers at DLS before, then you must 
do an initial podman setup::

    /dls_sw/apps/setup-podman/setup.sh

Second, in order to support secondary groups we require the crun container 
runtime. This should be installed by default but early adopters
will need::

    sudo yum install crun

Startup Script run-dev-c7.sh
----------------------------

Next, copy the startup script to your local bin directory and make it 
executable::

    curl https://raw.githubusercontent.com/dls-controls/dev-c7/main/run-dev-c7.sh -o $HOME/bin/run-dev-c7.sh
    chmod +x $HOME/bin/run-dev-c7.sh

Finally, launch an instance of the container by typing::

    run-dev-c7.sh

.. note::
    For the first invocation of an updated version of the container there 
    will be a 30 second delay while the filesystem user id namespace mapping 
    is cached.

See optional parameters to the startup script with::

    run-dev-c7.sh -h

Usage
-----

At a dev-c7 prompt you can work normally as if you were sitting at a RHEL7 
workstation. Everything should work as before although there are a few 
differences, see
`../explanations/differences`. 

If you find anything that does not work or have suggestions for improvement,
please report it `HERE <link URL>`_.

- You can launch multiple instances of dev-c7 and they will share the
  same container. 
- You can run gnome-terminal and open multiple tabs - all will be in the 
  container
- You can use module load as usual to make further software from dls_sw
  available
- You can run GUI apps as normal.
- You have full sudo rights and can install anything you need into the
  container with ``yum install``

Note that the container should be considered ephemeral. The system partition
can be changed but note:

- Changes inside the container such as ``yum install`` will be persisted, 
  but only until it is deleted.
- If you have permanent additions to the container that you would like
  to implement, see `deriving`

.. _deleting:

Deleting the container
----------------------

To reset the container back to its original state we ask podman 
to stop it and delete it. 

.. warning::

    Everything running in your container will be terminated when you
    do this. Make sure you have saved your work and closed all
    applications.


The following will stop the container and delete it's state. All
dev-c7 shells and any GUI apps launched from them will be closed::

    podman rm -ft0 dev-c7

When you next launch the container, it will be started with its file system
initialized back to the default state specified in the image at
ghcr.io/dls-controls/dev-c7:latest.

.. warning::
    Any changes you have made to the container itself will be lost when you 
    execute the above command. This includes
    any ``yum install`` and any changes to the operating system files.
    See `../explanations/how_it_works` for more detail. To permanently 
    persist changes see `deriving`.
