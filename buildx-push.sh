#!/usr/bin/env zsh

export VERSION_TAG=$1

set -euxo pipefail

./clean.sh

for name in vw vw-headless; do 
    pushd $name
    echo "$name build of $(date)" > ../$name.build.log
    docker buildx build \
        --build-arg VERSION_TAG=${VERSION_TAG} \
        --platform linux/amd64 \
        --tag soopsnl/devanyware-${name}:${VERSION_TAG} \
        --push \
        . \
    | tee -a ../$name.build.log
    popd
done
