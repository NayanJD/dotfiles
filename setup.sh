#!/bin/bash

source ./setup-debian.sh
#source ./setup darwin.sh

set -eox

os=$(uname -s)

if [ "$os" == "Linux" ]; then
  echo "Linux OS detected"
  
  if [ "$(grep -Ei 'debian|buntu|mint' /etc/*release)" ]; then
    echo "Debian distro detected"
    setup_debian
  else
    echo "Currently only debian distro is supported. Exiting!"
    exit
  fi
elif [ "$os" == "Darwin" ]; then
  echo "Darwin OS detected"

  setup_darwin
else
  echo "OS: ${os} not supported"
  exit 1
fi
