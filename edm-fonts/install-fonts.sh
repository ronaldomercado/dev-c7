#!/bin/bash

set -xe

sudo yum install https://github.com/dls-controls/dev-c7/raw/main/edm-fonts/dls-arial-1.0-1.noarch.rpm
sudo yum install https://github.com/dls-controls/dev-c7/raw/main/edm-fonts/dls-courier-1.0-1.noarch.rpm
sudo yum install https://github.com/dls-controls/dev-c7/raw/main/edm-fonts/dls-msttcore-1.0-1.noarch.rpm

echo Done