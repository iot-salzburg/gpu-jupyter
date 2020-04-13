# Deployment Notes

## Push image with tag to Dockerhub

Based on [this](https://ropenscilabs.github.io/r-docker-tutorial/04-Dockerhub.html) tutorial
with the tag `v1.0_cuda-10.1_ubuntu-18.04`:

```bash
# on il048:
cd ~/Documents/projects/GPU-Jupyter/gpu-jupyter
git pull
bash generate_Dockerfile.sh
bash start-local -p 1234
docker image ls
docker tag [IMAGE ID] cschranz/gpu-jupyter:v1.0_cuda-10.1_ubuntu-18.04
docker push cschranz/gpu-jupyter:v1.0_cuda-10.1_ubuntu-18.04
docker save cschranz/gpu-jupyter > ../gpu-jupyter_tag-v1.0_cuda-10.1_ubuntu-18.04.tar
```

Then, the new tag is available on [Dockerhub](https://hub.docker.com/repository/docker/cschranz/gpu-jupyter/tags).


## Deployment in the swarm

The GPU-Jupyter instance for deployment, that has swarm files and changed pw is
in `/home/iotdev/Documents/projects/dtz/src/gpu-jupyter`

```bash
# on il048:
cd /home/iotdev/Documents/projects/dtz/src/gpu-jupyter
git pull
bash generate_Dockerfile.sh
bash add-to-swarm-with-defaults.sh
```

Then, the service will be available with data stored in `data` 
on [192.168.48.48:8848](http://192.168.48.48:8848) with our password.

