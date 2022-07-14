#!/usr/bin/env zsh

export VERSION_TAG=$1

set -euxo pipefail

./clean.sh

for name in vw ; do 
    pushd $name
    echo "$name build of $(date)" > ../$name.build.log
    docker build \
        --build-arg VERSION_TAG=${VERSION_TAG} \
        --tag soopsnl/devanyware-${name}:${VERSION_TAG} \
        . \
    | tee -a ../$name.build.log
    popd
done