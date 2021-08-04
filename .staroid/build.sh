#!/bin/bash
# Custom builder script for Skaffold
# https://skaffold.dev/docs/pipeline-stages/builders/custom/
#

# generate Dockerfile
./generate-Dockerfile.sh --no-datascience-notebook
cd .build

## apply staroid patch
#cat ../.staroid/Dockerfile.staroid >> Dockerfile

# print Dockerfile
cat Dockerfile

# build
docker build -f Dockerfile -t $IMAGE .

if $PUSH_IMAGE; then
  docker push $IMAGE
fi
