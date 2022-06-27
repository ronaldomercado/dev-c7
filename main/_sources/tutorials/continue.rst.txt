More Features
=============

This tutorial takes you through a few additional features provided by the 
launch script.

Options
-------

To see optional parameters, run the launch script with -h::

    $ run-dev-c7.sh -h

    usage: run-dev-c7.sh [options]

    Launches a developer container that simulates a DLS RHEL7 workstation.

    Options:

        -h              show this help    
        -p              pull an updated version of the image first   
        -i image        specify the container image (default: ghcr.io/dls-controls/dev-c7)
        -v version      specify the image version (default: latest)
        -s host         set a hostname for your container (default: dev-c7)

Versions
--------

The default behaviour is that ``run-dev-c7.sh`` will use the latest version
of the container image that is cached locally. If there has been an update
to the image registry and you would like to pull that then use ``-p``::

    run-dev-c7.sh -p

If you would like to roll back to a previous version then use the -v 
option::

    run-dev-c7.sh -v 2.0.0-rc2

To check what versions of the image are available, take a look at the 
github container registry for this project 
https://ghcr.io/dls-controls/dev-c7

Lifetime
--------

Note that the container should be considered ephemeral. The system partition
can be changed and you have full sudo rights, but note:

- Changes inside the container such as ``yum install`` will be persisted, 
  but only until it is deleted.
- Deletion is under your control, see below. However you will always need
  to do a delete before updating to a new version. Therefore it is a bad
  idea to accumulate many changes inside of the container.
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
