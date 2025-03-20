#!/bin/bash

git clone --recursive https://github.com/NayanJD/dotfiles.git
      
export SKIP_NERDCTL_INSTALL=true
export SKIP_CONTAINERD_INSTALL=true

cd dotfiles && ./setup.sh

