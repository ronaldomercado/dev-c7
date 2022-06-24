Managing Containers and Images on a Workstation
===============================================

Intro
-----

**Images** are snapshots of a filesystem used to bootstrap a container.

**Containers** are isolated execution environments with their file system based
upon an Image.

Monitoring
----------

You can see which **Containers** are running on your system with::

    podman ps -a

The ``-a`` means it will also show stopped containers.

You can see what **Images** are cached on your system with::

    podman images

Images are usually cached from a container registry like ghcr.io. They can
usually be deleted without any consequence except waiting for the download
next time you launch a container that uses them.

Cleaning Up Space
-----------------

The container and image cache is stored in /scratch/<fed_id>/podman. If you
are short on space you can use the following.

To remove temporary images and stopped containers::

    podman system prune

To remove individual images::

    podman rmi IMAGE_ID # from third column of podman images

    OR ...

    podman rmi REPOSITORY:TAG # 1st , 2nd columns of podman images

To remove all images with wildcard on REPOSITORY::

    podman rmi $(podman images --filter=reference='*PATTERN*' -q)

    # PATTERN matches the REPOSITORY column


.. _dockerfile:

Defining a Container Image
--------------------------

A container image is defined in terms of a Dockerfile. This simply defines
a base image with the ``FROM`` command and then executes a series of commands
each of which adds a layer of changes to the filesystem.

The majority of the Dockerfile for ``dev-c7`` is using yum install to get 
packages installed into the OS.

TODO - discuss more detail and suggest what contributors might add.

.. literalinclude:: ../../docker/Dockerfile
   :language: docker
