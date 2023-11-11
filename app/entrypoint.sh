#!/bin/sh
## Entrypoint script for FoundryVTT

FOUNDRYVTT_DATA_PATH=${FOUNDRYVTT_DATA_PATH:=/data/foundryvtt}
FOUNDRYVTT_LISTEN_PORT=${FOUNDRYVTT_LISTEN_PORT:=8080}
FOUNDRYVTT_INSTALL_PATH=${FOUNDRYVTT_INSTALL_PATH:=/usr/src/app/foundryvtt}

echo "THIS CONTAINERIZATION PROJECT IS NOT AFFILIATED WITH FoundryVTT.com and DOES NOT CONTAIN FoundryVTT ITSELF!"

## check_foundryvtt_installation will look for resources/app/main.js in $FOUNDRYVTT_INSTALL_PATH.
check_foundryvtt_installation () {
  if [ ! -d "$FOUNDRYVTT_INSTALL_PATH" ]; then
    echo "WARNING: ${FOUNDRYVTT_INSTALL_PATH} does not exist. Creating directory, but the installation will most likely not be persisted."
    echo "Set \$FOUNDRYVTT_INSTALL_PATH to a directory that is a mounted volume."
    mkdir -p ${FOUNDRYVTT_INSTALL_PATH}
  fi

  if [ -f "${FOUNDRYVTT_INSTALL_PATH}/resources/app/main.js" ]; then
    echo "FoundryVTT found in ${FOUNDRYVTT_INSTALL_PATH}."
    return 0
  else
    return 1
  fi
}

## install_foundryvtt will install FoundryVTT from a timed download URL
## obtained from FoundryVTT.com and provided through ENV $FOUNDRYVTT_DOWNLOAD_URL
install_foundryvtt () {
  if [ "${FOUNDRYVTT_DOWNLOAD_URL}" = "" ]; then
    return
  fi
  echo "Installing FoundryVTT from URL ${FOUNDRYVTT_DOWNLOAD_URL}..."
  wget -O foundryvtt.zip ${FOUNDRYVTT_DOWNLOAD_URL}
  if [ $? -ne 0 ]; then
    echo "ERROR: Unable to download FoundryVTT!"
    exit 1
  fi
  unzip foundryvtt.zip -d ${FOUNDRYVTT_INSTALL_PATH}
}

main () {
  ## Data dir exists?
  if [ ! -d "$FOUNDRYVTT_DATA_PATH" ]; then
    echo "WARNING: ${FOUNDRYVTT_DATA_PATH} does not exist. Creating directory, but your data will most likely not be persisted."
    echo "Set $FOUNDRYVTT_DATA_PATH to a directory that is a mounted volume."
    mkdir -p ${FOUNDRYVTT_DATA_PATH}
  fi

  if ! check_foundryvtt_installation; then
    install_foundryvtt
    if ! check_foundryvtt_installation; then
      cd foundry-instructions/
      npm install .
      ember serve --port 8080 --environment=production
    fi
  fi
}

main

## Start FoundryVTT
exec /usr/local/bin/node ${FOUNDRYVTT_INSTALL_PATH}/resources/app/main.js --dataPath=${FOUNDRYVTT_DATA_PATH} --noupnp --port=${FOUNDRYVTT_LISTEN_PORT}
