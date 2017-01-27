#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"
pwd
VERSION=1.9.14
IMAGE=1000kit/testlink
echo "build base docker image"

docker build --rm --force-rm -t ${IMAGE} .

echo "tag image with version ${VERSION}"
docker tag ${IMAGE} ${IMAGE}:${VERSION}


#end
