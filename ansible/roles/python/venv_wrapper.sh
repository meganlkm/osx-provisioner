#!/bin/bash

export PROJECT_HOME="${HOME}/dev"
export WORKON_HOME="${PROJECT_HOME}/ENVS"

[[ ! -d $WORKON_HOME  ]] && mkdir -p $WORKON_HOME
[[ ! -d $PROJECT_HOME  ]] && mkdir -p $PROJECT_HOME

source /usr/local/bin/virtualenvwrapper.sh

