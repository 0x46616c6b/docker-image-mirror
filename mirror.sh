#!/bin/bash

usage() {
  cat <<EOF
  usage: $0 -r <registry_host> -i <images>

  This script mirrors docker images to our docker registry.

  OPTIONS:
     -h   Show this message
     -i   Docker images to mirror: "library/ubuntu library/redis"
     -r   Docker registry to mirror: "example.com"
EOF
}

type docker >/dev/null 2>&1 || {
  echo >&2 "Docker required ;-)";
  exit 1
}

IMAGES=
REGISTRY=

while getopts "h:r:i:" OPTION
do
  case $OPTION in
    h)
      usage
      exit 1
      ;;
    r)
      REGISTRY=$OPTARG
      ;;
    i)
      IMAGES=$OPTARG
      ;;
    ?)
      usage
      exit
    ;;
  esac
done

if [[ -z $REGISTRY ]] || [[ -z $IMAGES ]]; then
  usage
  exit 1
fi

for IMAGE in $IMAGES; do
  docker pull -a $IMAGE

  TAGS=$(docker images|grep -G "^${IMAGE}[[:blank:]]"|awk '{print $2}'|sort|uniq)

  for TAG in $TAGS; do
    docker tag -f $IMAGE:$TAG $REGISTRY/$IMAGE:$TAG
  done

  docker push $REGISTRY/$IMAGE
done
