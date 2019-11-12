#!/usr/bin/env bash
cd $(cd -P -- "$(dirname -- "$0")" && pwd -P)

if [[ -n "$1" ]]; then
    result=$(docker network ls)
    if [[ "$result" == *" $1 "* ]]; then
        echo "Adding gpu-jupyter to the swarm in the network $1."
        export JUPYTER_NETWORK=$1
        # echo $JUPYTER_NETWORK
        docker-compose -f docker-compose-swarm.yml build
        docker-compose -f docker-compose-swarm.yml push
#        docker stack deploy --compose-file docker-compose-swarm.yml gpu
    else
        echo "Could not find network $1. Please provide a valid docker network."
    fi
else
    echo "Usage: $0 network"
    echo "Please set the network"
fi

