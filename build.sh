#!/bin/bash

TAG=${1-"local"}

set -e  # fail whenever a cmd fails
if [ -z $(command -v docker) ]; then
  echo -e "${FAIL_STRING} Docker binary not found"
  exit 127
fi

# Run in script directory
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $SCRIPTPATH

docker buildx build --load -t pgschk/foundryvtt-containerized:${TAG} .
