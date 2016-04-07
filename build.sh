#!/bin/bash 

MY_PATH="`dirname \"$0\"`"
MY_PATH="`( cd \"$MY_PATH\" && pwd )`"  # absolutized and normalized

MY_REPO=""
MY_PROJECT="`basename \"$MY_PATH\"`"
if [ "$#" -ne 1 ]; then
    echo "Usage: ${MY_PROJECT} <container_version>"
    exit 1
fi

TAG="$1"
PREFIX=wp


docker build -t ${PREFIX}-nginx:${TAG} nginx
docker tag ${PREFIX}-nginx:${TAG} ${PREFIX}-nginx:latest
#docker push ${MY_REPO}${PREFIX}-nginx:${TAG}
#docker push ${MY_REPO}${PREFIX}-nginx:latest

docker build -t ${PREFIX}-wordpress:${TAG} wordpress
docker tag ${PREFIX}-wordpress:${TAG} ${PREFIX}-wordpress:latest
#docker push ${MY_REPO}${PREFIX}-wordpress:${TAG}
#docker push ${MY_REPO}${PREFIX}-wordpress:latest
