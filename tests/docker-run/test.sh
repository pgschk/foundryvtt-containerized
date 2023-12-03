#!/bin/bash

OK_STRING="\e[42m[OK]\e[0m"
FAIL_STRING="\e[41m[FAIL]\e[0m"

# Run in script directory
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $SCRIPTPATH

set -e  # fail whenever a cmd fails
if [ -z $(command -v docker) ]; then
  echo -e "${FAIL_STRING} docker binary not found"
  exit 127
fi

INSTALL_ID=$(uuidgen)
TEMPDIR=$(mktemp -d)

function cleanup {
  echo -e "${OK_STRING} Cleaning up..."
  if [ ! -z ${container} ]; then
    echo -e "${OK_STRING} Stopping container ${container}"
    docker stop ${container}
  fi
  echo -e "${OK_STRING} Removing temporary directory"
  rm -Rf ${TEMPDIR}
    echo -e "${OK_STRING} Done"
}
trap cleanup EXIT

if [ -z ${FOUNDRYVTT_CONTAINERIZED_EXISTING_IMAGE} ]; then
  echo -e "${OK_STRING} Building into pgschk/foundryvtt-containerized:${INSTALL_ID}..."
  docker buildx build --no-cache -t pgschk/foundryvtt-containerized:${INSTALL_ID} ../..
  IMAGE_NAME=pgschk/foundryvtt-containerized:${INSTALL_ID}
else
  echo -e "${OK_STRING} Using existing image ${FOUNDRYVTT_CONTAINERIZED_EXISTING_IMAGE}"
  IMAGE_NAME=${FOUNDRYVTT_CONTAINERIZED_EXISTING_IMAGE}
fi

if [ -z ${IMAGE_NAME} ]; then
  echo -e "${FAIL_STRING} No valid docker image identified"
  exit 128
fi

cd ${TEMPDIR}
container=$(docker run -d --rm --user $UID -p 8080:8080 -v ${TEMPDIR}/data:/data/foundry -v ${TEMPDIR}/install:/usr/src/app/foundryvtt -e FOUNDRYVTT_DOWNLOAD_URL="${FOUNDRYVTT_DOWNLOAD_URL}" ${IMAGE_NAME})
if [ "$?" -ne "0" ]; then
  echo -e "${FAIL_STRING} Error":
  echo $container
else
  sleep 10
  curl -so /dev/null http://localhost:8080
  if [ "$?" -ne "0" ]; then
    echo -e "${FAIL_STRING} Container webserver not reachable"
  else
    echo -e "${OK_STRING} Container webserver reachable"
  fi
fi
