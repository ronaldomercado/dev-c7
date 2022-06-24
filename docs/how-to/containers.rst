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

The ``-a`` means it will also show stopped containers 

You can see what **Images** are cached on your system with::

    podman images

Cleaning Up Space
-----------------

TODO

