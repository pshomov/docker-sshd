#!/bin/sh
set -euxo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

REPOSITORY=pshomov/docker-sshd
PUSH=${PUSH:-false}

build_push() {
  image=$1

  echo; echo "Building $image"
  docker build -t "$image" .

  echo; echo "Pushing $image"
  if [[ "true" == "$PUSH" ]] ; then
   docker push "$image"
  fi
}

build_push $REPOSITORY
