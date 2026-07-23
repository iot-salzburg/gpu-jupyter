#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
cd "$SCRIPT_DIR"

# extract the branch-name that is built and pushed
export TAGNAME=$(git symbolic-ref -q HEAD)
export TAGNAME=${TAGNAME##refs/heads/}
export TAGNAME=${TAGNAME:-HEAD}
# manually set tag
# export TAGNAME="v1.5_cuda-11.6_ubuntu-20.04"
echo "Build and push images full, python-only & slim for branch '$TAGNAME'."
if [[ "$TAGNAME" != "v"*"_cuda-"*"_ubuntu-"* ]]; then
    echo "ERROR, build_push_all.sh only possible within branches of shape 'v'*'_cuda-'*'_ubuntu-'*."
    exit 1
fi

###################### build, run and push full image ##########################
echo
echo
echo "build, run and push full image with tag $TAGNAME."
bash generate-Dockerfile.sh
docker build --no-cache -t cschranz/gpu-jupyter:$TAGNAME .build/  # build this from a fresh install

docker rm -f gpu-jupyter_1 2>/dev/null || true
docker run --gpus all -d -it -p 8848:8888 -v "$(pwd)/data:/home/jovyan/work" -e GRANT_SUDO=yes -e JUPYTER_ENABLE_LAB=yes --user root --restart always --name gpu-jupyter_1 cschranz/gpu-jupyter:$TAGNAME
docker push cschranz/gpu-jupyter:$TAGNAME


###################### build and push slim image ##########################
echo
echo
echo "build and push slim image with tag ${TAGNAME}_slim."
bash generate-Dockerfile.sh --slim
docker build -t cschranz/gpu-jupyter:${TAGNAME}_slim  .build/
docker push cschranz/gpu-jupyter:${TAGNAME}_slim


###################### build and push python-only image ##########################
echo
echo
echo "build and push python-only image with tag ${TAGNAME}_python-only."
bash generate-Dockerfile.sh --python-only
docker build -t cschranz/gpu-jupyter:${TAGNAME}_python-only  .build/
docker push cschranz/gpu-jupyter:${TAGNAME}_python-only
