#!/bin/bash

# error-codes:
# - 127: Docker not found
# - 128: No valid docker image
# - 22: No FoundryVTT installation found in container

OK_STRING="\e[42m[OK]\e[0m"
FAIL_STRING="\e[41m[FAIL]\e[0m"

INSTALL_SUCCESSFULL_EXPECTED=${FOUNDRYVTT_CONTAINERIZED_INSTALL_SUCCESS_EXPECTED-false}

# Run in script directory
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $SCRIPTPATH

set -e  # fail whenever a cmd fails
if [ -z $(command -v docker) ]; then
  echo -e "${FAIL_STRING} Docker binary not found"
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
mkdir -p ${TEMPDIR}/data ${TEMPDIR}/install
container=$(docker run -d --rm --user $UID -p 8080:8080 -v ${TEMPDIR}/data:/data/foundry -v ${TEMPDIR}/install:/usr/src/app/foundryvtt -e FOUNDRYVTT_DOWNLOAD_URL="${FOUNDRYVTT_DOWNLOAD_URL}" ${IMAGE_NAME})
if [ "$?" -ne "0" ]; then
  echo -e "${FAIL_STRING} Error":
  echo $container
else
  if [ "${INSTALL_SUCCESSFULL_EXPECTED}" == "true" ]; then
    echo -e "${OK_STRING} Testing for successful FoundryVTT installation..."
    sleep 20
    curl -so /dev/null --fail-with-body http://localhost:8080/api/status &> /dev/null
    # Exit code 22 means error 404 on curl, meaning not FoundryVTT installation success
    if [ "$?" -ne "0" ]; then
      echo -e "${FAIL_STRING} Container webserver not reachable"
    else
      echo -e "${OK_STRING} Container webserver reachable"
    fi
  else
    # Only testing for the placeholder application, because we don't expect a successful installation
    # most likely due to no valid $FOUNDRYVTT_DOWNLOAD_URL
    echo -e "${OK_STRING} Testing only for reachable webserver, not for FoundryVTT installation..."
    sleep 10
    curl -v http://localhost:8080
    if [ "$?" -ne "0" ]; then
      echo -e "${FAIL_STRING} Container webserver not reachable"
    else
      echo -e "${OK_STRING} Container webserver reachable"
    fi
  fi
fi
