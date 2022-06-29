#!/bin/bash

# a script to locally test documentation build.

root=$(realpath $(dirname ${BASH_SOURCE[0]})/..)

set -e 

if [[ ! -d "${root}/.venv" ]] ; then
    virtualenv "${root}/.venv" --python python3
    source "${root}/.venv/bin/activate"
    pip install -r "${root}/requirements.txt"
fi

source "${root}/.venv/bin/activate"
sphinx-build -EWT --keep-going docs ${root}/build/html "${@}"