#!/bin/env bash
command_exists() {
  command -v "$@" >/dev/null 2>&1
}
IMG=${1:-nichtsen/srvgo}
TAG=${2:-v3}
Repo=$IMG:$TAG
echo try to build ${Repo}

command_exists docker || return 1

docker build -t $Repo -f Dockerfile . && docker push $Repo;

