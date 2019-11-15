#!/usr/bin/env bash
cd $(cd -P -- "$(dirname -- "$0")" && pwd -P)

# Fetching port and network as input
PORT=8888
while [[ "$#" -gt 0 ]]; do case $1 in
  -p|--port) PORT="$2"; shift;;
  -n|--network) NETWORK="$2"; shift;;
#  -u|--uglify) uglify=1;;
  *) echo "Unknown parameter passed: $1"; exit 1;;
esac; shift; done

# Check if arguments are valid
if [[ $PORT != [0-9][0-9][0-9][0-9]* ]]; then
    echo "Given port is not valid."
    echo "Usage: $0 -p [port] -n [docker-network]  # port must be an integer with 4 or more digits."
    exit 21
fi

if [[ $NETWORK == "" ]]; then
    echo "No docker network was provided to which this gpu-jupyter should be added to."
    echo "Usage: $0 -p [port] -n [docker-network]  # port must be an integer with 4 or more digits."
    exit 22
fi
result=$(docker network ls)
if [[ "$result" != *" $NETWORK "* ]]; then
    echo "Could not find network $NETWORK. Please provide a valid docker network."
    echo "Please select a network:"
    docker network ls
    exit 23
fi

# starting in swarm
export HOSTNAME=$(hostname)
export JUPYTER_PORT=$PORT
export JUPYTER_NETWORK=$NETWORK
echo "Adding gpu-jupyter to the swarm on the node $HOSTNAME in the network $NETWORK on port $PORT."
# echo $JUPYTER_NETWORK
envsubst < docker-compose-swarm.yml > .docker-compose-swarm.yml.envsubst
docker-compose -f .docker-compose-swarm.yml.envsubst build
docker-compose -f .docker-compose-swarm.yml.envsubst push
docker stack deploy --compose-file .docker-compose-swarm.yml.envsubst gpu
rm .docker-compose-swarm.yml.envsubst

echo
echo "Added gpu-jupyter to docker swarm $NETWORK on port $JUPYTER_PORT."
echo "See 'docker service ps gpu_gpu-jupyter' for status info."
echo "See 'docker service logs -f gpu_gpu-jupyter' for logs."
