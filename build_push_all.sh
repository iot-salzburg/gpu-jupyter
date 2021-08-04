#!/usr/bin/env bash
cd $(cd -P -- "$(dirname -- "$0")" && pwd -P)

export TAGNAME="v1.4_cuda-11.0_ubuntu-20.04"


###################### build, run and push full image ##########################
echo
echo
echo "build, run and push full image with tag $TAGNAME."
bash generate-Dockerfile.sh
docker build --no-cache -t cschranz/gpu-jupyter:$TAGNAME .build/

export IMG_ID=$(docker image ls | grep $TAGNAME | grep -v _python-only | grep -v _slim | head -1 | awk '{print $3}')
echo "push image with ID $IMG_ID and Tag $TAGNAME ."

docker tag $IMG_ID cschranz/gpu-jupyter:$TAGNAME
docker rm -f gpu-jupyter_1
docker run --gpus all -d -it -p 8848:8888 -v $(pwd)/data:/home/jovyan/work -e GRANT_SUDO=yes -e JUPYTER_ENABLE_LAB=yes --user root --restart always --name gpu-jupyter_1 cschranz/gpu-jupyter:$TAGNAME

docker push cschranz/gpu-jupyter:$TAGNAME


###################### build and push slim image ##########################
echo
echo
echo "build and push slim image with tag ${TAGNAME}_slim."
bash generate-Dockerfile.sh --slim
docker build -t cschranz/gpu-jupyter:${TAGNAME}_slim  .build/

export IMG_ID=$(docker image ls | grep ${TAGNAME}_slim  | head -1 | awk '{print $3}')
echo "push image with ID $IMG_ID and Tag ${TAGNAME}_slim."

docker tag $IMG_ID cschranz/gpu-jupyter:${TAGNAME}_slim
docker push cschranz/gpu-jupyter:${TAGNAME}_slim


###################### build and push python-only image ##########################
echo
echo
echo "build and push slim image with tag ${TAGNAME}_python-only."
bash generate-Dockerfile.sh --python-only
docker build -t cschranz/gpu-jupyter:${TAGNAME}_python-only  .build/

export IMG_ID=$(docker image ls | grep ${TAGNAME}_python-only  | head -1 | awk '{print $3}')
echo "push image with ID $IMG_ID and Tag ${TAGNAME}_python-only."

docker tag $IMG_ID cschranz/gpu-jupyter:${TAGNAME}_python-only
docker push cschranz/gpu-jupyter:${TAGNAME}_python-only
