#!/usr/bin/env bash
cd $(cd -P -- "$(dirname -- "$0")" && pwd -P)

export TAGNAME="v1.3_cuda-10.1_ubuntu-18.04"


###################### build, run and push full image ##########################
echo
echo
echo "build, run and push full image with tag $TAGNAME."
bash generate-Dockerfile.sh
docker build -t cschranz/gpu-jupyter:$TAGNAME .build/

export IMG_ID=$(docker image ls | grep $TAGNAME | grep -v _python-only | grep -v _slim | head -1 | awk '{print $3}')
echo "push image with ID $IMG_ID and Tag $TAGNAME ."

docker tag $IMG_ID cschranz/gpu-jupyter:$TAGNAME
docker rm -f gpu-jupyter_1
docker run --gpus all -d -it -p 8848:8888 -v $(pwd)/data:/home/jovyan/work -e GRANT_SUDO=yes -e JUPYTER_ENABLE_LAB=yes --user root --restart always --name gpu-jupyter_1 cschranz/gpu-jupyter:$TAGNAME

docker push cschranz/gpu-jupyter:$TAGNAME &&
docker save cschranz/gpu-jupyter:$TAGNAME | gzip > ../gpu-jupyter_tag-$TAGNAME.tar.gz


###################### build and push slim image ##########################
echo
echo
echo "build and push slim image with tag ${TAGNAME}_slim."
bash generate-Dockerfile.sh --slim
docker build -t cschranz/gpu-jupyter:${TAGNAME}_slim  .build/

export IMG_ID=$(docker image ls | grep ${TAGNAME}_slim  | head -1 | awk '{print $3}')
echo "push image with ID $IMG_ID and Tag ${TAGNAME}_slim."

docker tag $IMG_ID cschranz/gpu-jupyter:${TAGNAME}_slim
docker push cschranz/gpu-jupyter:${TAGNAME}_slim &&
docker save cschranz/gpu-jupyter:${TAGNAME}_slim | gzip > ../gpu-jupyter_tag-${TAGNAME}_slim.tar.gz



###################### build and push python-only image ##########################
echo
echo
echo "build and push slim image with tag ${TAGNAME}_slim."
bash generate-Dockerfile.sh --slim
docker build -t cschranz/gpu-jupyter:${TAGNAME}_slim  .build/

export IMG_ID=$(docker image ls | grep ${TAGNAME}_slim  | head -1 | awk '{print $3}')
echo "push image with ID $IMG_ID and Tag ${TAGNAME}_slim."

docker tag $IMG_ID cschranz/gpu-jupyter:${TAGNAME}_slim
docker push cschranz/gpu-jupyter:${TAGNAME}_slim &&
docker save cschranz/gpu-jupyter:${TAGNAME}_slim | gzip > ../gpu-jupyter_tag-${TAGNAME}_slim.tar.gz

