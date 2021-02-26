#!/usr/bin/env bash
cd $(cd -P -- "$(dirname -- "$0")" && pwd -P)

# Fetching port and network as input
PORT=8888
while [[ "$#" -gt 0 ]]; do case $1 in
  -p|--port) PORT="$2"; shift;;
#  -u|--uglify) uglify=1;;
  *) echo "Unknown parameter passed: $1"; exit 1;;
esac; shift; done

# Check if arguments are valid
if [[ $PORT != [0-9][0-9][0-9][0-9]* ]]; then
    echo "Given port is not valid."
    echo "Usage: $0 -p [port]  # port must be an integer with 4 or more digits."
    exit 21
fi

# starting in docker-compose
echo "Starting gpu-jupyter via docker-compose on port $PORT."
export JUPYTER_PORT=$PORT
export UID=$(id -u)
export GID=$(id -g)

# echo $JUPYTER_PORT
bash generate-Dockerfile.sh
docker-compose up --build -d

if [ $? -eq 0 ]; then
  echo
  echo "Started gpu-jupyter via docker-compose on localhost:$JUPYTER_PORT."
  echo "See docker-compose logs -f for logs."
else
  echo
  echo "Could not start the container with docker-compose."
  echo "Please check the logs and if your docker-compose version is at least 1.28.0. Your version is:"
  docker-compose --version
fi
