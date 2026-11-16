#!/bin/sh
## Entrypoint script for FoundryVTT

FOUNDRYVTT_DATA_PATH=${FOUNDRYVTT_DATA_PATH:=/data/foundryvtt}
FOUNDRYVTT_LISTEN_PORT=${FOUNDRYVTT_LISTEN_PORT:=8080}
FOUNDRYVTT_INSTALL_PATH=${FOUNDRYVTT_INSTALL_PATH:=/usr/src/app/foundryvtt}

echo "THIS CONTAINERIZATION PROJECT IS NOT AFFILIATED WITH FoundryVTT.com and DOES NOT CONTAIN FoundryVTT ITSELF!"

## check_foundryvtt_installation will look for main.js in $FOUNDRYVTT_INSTALL_PATH.
check_foundryvtt_installation () {
  if [ ! -d "$FOUNDRYVTT_INSTALL_PATH" ]; then
    echo "WARNING: ${FOUNDRYVTT_INSTALL_PATH} does not exist. Creating directory, but the installation will most likely not be persisted."
    echo "Set \$FOUNDRYVTT_INSTALL_PATH to a directory that is a mounted volume."
    mkdir -p "$FOUNDRYVTT_INSTALL_PATH"
  fi

  if [ -f "${FOUNDRYVTT_INSTALL_PATH}/main.js" ]; then
    echo "FoundryVTT found in ${FOUNDRYVTT_INSTALL_PATH}"
    return 0
  else
    return 1
  fi
}

## install_foundryvtt will install FoundryVTT from a timed download URL
## obtained from FoundryVTT.com and provided through ENV $FOUNDRYVTT_DOWNLOAD_URL.
## The URL is tied to a license, so it is never printed.
install_foundryvtt () {
  if [ -z "$FOUNDRYVTT_DOWNLOAD_URL" ]; then
    return
  fi
  echo "Installing FoundryVTT from the timed download URL..."
  zip=$(mktemp)
  if ! wget -q -O "$zip" "$FOUNDRYVTT_DOWNLOAD_URL"; then
    echo "ERROR: Unable to download FoundryVTT!"
    rm -f "$zip"
    return
  fi
  unzip -o -q "$zip" -d "$FOUNDRYVTT_INSTALL_PATH"
  rm -f "$zip"
}

start_foundryvtt () {
  echo "-------------------"
  echo "Starting FoundryVTT"
  echo "-------------------"
  exec node "${FOUNDRYVTT_INSTALL_PATH}/main.js" --dataPath="$FOUNDRYVTT_DATA_PATH" --noupnp --port="$FOUNDRYVTT_LISTEN_PORT"
}

main () {
  ## Data dir exists?
  if [ ! -d "$FOUNDRYVTT_DATA_PATH" ]; then
    echo "WARNING: ${FOUNDRYVTT_DATA_PATH} does not exist. Creating directory, but your data will most likely not be persisted."
    echo "Set \$FOUNDRYVTT_DATA_PATH to a directory that is a mounted volume."
    mkdir -p "$FOUNDRYVTT_DATA_PATH"
  fi

  if ! check_foundryvtt_installation; then
    install_foundryvtt
    if ! check_foundryvtt_installation; then
      # Installation did not succeed, display instructions website instead.
      echo "ERROR: FoundryVTT installation failed! Starting webserver to provide instructions."
      exec darkhttpd /usr/src/app/foundry-instructions/ --port "$FOUNDRYVTT_LISTEN_PORT"
    fi
  fi
  start_foundryvtt
}

main
