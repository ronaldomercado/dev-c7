#!/bin/sh

# a few tweaks to make the devcontainer environment work well after first 
# creation

sed -i s#/bin/sh#/bin/bash# /etc/passwd
echo "127.0.0.1 $HOSTNAME" >> /etc/hosts

