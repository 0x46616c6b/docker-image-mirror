#!/bin/bash

usage() {
  cat <<EOF
  usage: $0 -r <registry_host> -i <images>

  docker-image-mirror copy docker images to your private docker registry.

  OPTIONS:
     -h   Show this message
     -i   Docker images to mirror: "library/ubuntu library/redis"
     -r   Docker registry to mirror: "example.com"
     -t   Docker image tag (fetch only this tag)
EOF
}

type docker >/dev/null 2>&1 || {
  echo >&2 "Docker required ;-)";
  exit 1
}

IMAGES=
REGISTRY=
TAG=

while getopts "h:r:i:t:" OPTION
do
  case $OPTION in
    h)
      usage
      exit 1
      ;;
    r)
      REGISTRY=$OPTARG
      ;;
    t)
      TAG=$OPTARG
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
  if ! [[ -z $TAG ]]; then
    docker pull $IMAGE:$TAG
  else
    docker pull -a $IMAGE
  fi

  TRUNCIMAGE=$(echo $IMAGE|sed 's/library\///')
  TAGS=$(docker images|grep -G "^${TRUNCIMAGE}[[:blank:]]"|awk '{print $2}'|sort|uniq)

  for TAG in $TAGS; do
    docker tag $IMAGE:$TAG $REGISTRY/$IMAGE:$TAG
    docker push $REGISTRY/$IMAGE:$TAG
  done
done
