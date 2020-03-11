#!/usr/bin/env bash
cd $(cd -P -- "$(dirname -- "$0")" && pwd -P)

./add-to-swarm.sh -p 8848 -n elk_datastack -r 5001
