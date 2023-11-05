#!/bin/bash

OK_STRING="\e[42m[OK]\e[0m"
FAIL_STRING="\e[41m[FAIL]\e[0m"

set -e  # fail whenever a cmd fails
if [ -z $(command -v docker) ]; then
  echo -e "${FAIL_STRING} docker binary not found."
  exit 127
fi

INSTALL_ID=$(uuidgen)
TEMPDIR=$(mktemp -d)

function cleanup {
  echo -n "Cleaning up..."
  rm -R ${TEMPDIR}
  echo "done"
}
trap cleanup EXIT

docker buildx build -t pgschk/foundryvtt-containerized:${INSTALL_ID} ..

cd ${TEMPDIR}
mkdir install data && chown 1000 install data
docker run --rm --user 1000:1000 -p 8080:8080 -v ${TEMPDIR}/data:/data/foundry -v ${TEMPDIR}/install:/usr/src/app/foundryvtt -e FOUNDRYVTT_DOWNLOAD_URL="<your-timed-download-url>" pgschk/foundryvtt-containerized:${INSTALL_ID}
