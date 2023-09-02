#!/usr/bin/env bash

# Silence Docker CLI hints
export DOCKER_CLI_HINTS=false

export BINARY="tracedsp"
export GITTAG="v0.12"
export GITREPO="https://github.com/EarthScope/tracedsp"

# Resolve location of script directory
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Define binary output directory and ZIP archive
BIN_OUTPUT="${SCRIPT_DIR}/bin"
ZIP_OUTPUT="${SCRIPT_DIR}/${BINARY}-${GITTAG}-lambda-layer.zip"

# Make sure output artifacts are clear
rm -r -f "$BIN_OUTPUT"
mkdir -p "$BIN_OUTPUT"
rm -f "$ZIP_OUTPUT"

# Build docker image and binary
docker build \
  --build-arg BINARY \
  --build-arg GITTAG \
  --build-arg GITREPO \
  -t ${BINARY}-build -f Dockerfile . \

# Copy binary to BIN_OUTPUT, remove container on completion
docker run --rm \
  --mount type=bind,source="${BIN_OUTPUT}",target=/out \
  ${BINARY}-build \
  /bin/bash -c "cp /${BINARY}-${GITTAG} /out/"

# Build ZIP archive of the opt output
echo "Building ZIP archive of Lambda Layer"
zip -r "$ZIP_OUTPUT" bin

echo "'$ZIP_OUTPUT' can be deployed as a Lambda Layer"
