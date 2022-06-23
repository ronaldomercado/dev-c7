How the dev-c7 container works
==============================


Container lifetime
------------------

The script run-dev-c7.sh launches a container in the background using 
podman. It then executes an interactive bash shell inside of that 
container.

This means that when you exit the bash prompt the container continues to
run in the background. 

Further invocations of run-dev-c7.sh will execute further interactive bash
shells in the same container.

If the container is stopped (via podman stop dev-c7 or due to a host
reboot) then the next invocation of ``run-dev-c7.sh`` will detect this and 
restart it.

Because of this the dev-c7 container is not ephemeral like most containers,
it persists changes that you make in the OS until it is explicitly deleted.

File Systems
------------

The system partition in which the operating system is installed resides 
inside the container. However run-dev-c7.sh mounts a number of host and 
shared file systems. This is how the container is made to look very
similar to a RHEL7 workstation. The mounted file systems are as follows:: 

    /dls_sw/prod:/dls_sw/prod
    /dls_sw/work:/dls_sw/work
    /dls_sw/epics:/dls_sw/epics
    /dls_sw/targetOS/vxWorks/Tornado-2.2:/dls_sw/targetOS/vxWorks/Tornado-2.2
    /dls_sw/apps:/dls_sw/apps
    /dls_sw/etc:/dls_sw/etc
    /scratch:/scratch
    /home:/home
    /tmp:/tmp
    /dls/science/users/:/dls/science/users/

User Profile
------------

``run-dev-c7.sh`` executes ``bash -l`` in order to create an interactive
shell in the container. The following features make this work:

- The home directories folder /home is mounted
- the HOME environment variable is passed into the container
- your user id is mapped into the container namespace

The above points mean that bash is able to run ``.bash_profile`` from your 
home directory under your account. Hence all the usual DLS profile 
features are loaded.

TODO
----

Add more details here ...