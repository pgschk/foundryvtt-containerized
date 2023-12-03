#!/bin/bash

# error-codes:
# - 127: Docker not found
# - 128: No valid docker image
# - 22: No FoundryVTT installation found in container

OK_STRING="\e[42m[OK]\e[0m"
FAIL_STRING="\e[41m[FAIL]\e[0m"


# Get the directory of the script
script_dir=$(dirname "$(readlink -f "$0")")

# Override FOUNDRYVTT_CONTAINERIZED_INSTALL_SUCCESS_EXPECTED for the docker-run test
FOUNDRYVTT_CONTAINERIZED_INSTALL_SUCCESS_EXPECTED=false ${script_dir}/../docker-run/test.sh