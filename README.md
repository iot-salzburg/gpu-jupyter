# GPU-Jupyter
#### Leverage Jupyter Notebooks with the power of your NVIDIA GPU and perform GPU calculations using Tensorflow and Pytorch in collaborative notebooks. 

![Jupyterlab Overview](/extra/jupyterlab-overview.png)

First of all, thanks to [docker-stacks](https://github.com/jupyter/docker-stacks) 
for creating and maintaining a robost  Python, R and Julia toolstack for Data Analytics/Science 
applications. This project uses the NVIDIA CUDA image as a basis image and installs their 
toolstack on top of it to enable GPU calculations in the Jupyter notebooks. 
The image of this repository is available on [Dockerhub](https://hub.docker.com/r/cschranz/gpu-jupyter).

## Contents

1. [Requirements](#requirements)
2. [Quickstart](#quickstart)
3. [Tracing](#tracing)
4. [Deployment](#deployment-in-the-docker-swarm)
5. [Configuration](#configuration)
6. [Issues and Contributing](#issues-and-contributing)


## Requirements

1.  Install [Docker](https://www.docker.com/community-edition#/download) version **1.10.0+**
 and [Docker Compose](https://docs.docker.com/compose/install/) version **1.6.0+**.
2.  A NVIDIA GPU
3.  Get access to use your GPU via the CUDA drivers, check out this 
[medium article](https://medium.com/@christoph.schranz/set-up-your-own-gpu-based-jupyterlab-e0d45fcacf43).
    The CUDA toolkit is not required on the host system, as it will be deployed 
    in [NVIDIA-docker](https://github.com/NVIDIA/nvidia-docker).
4. Clone the Repository or pull the image from 
    [Dockerhub](https://hub.docker.com/repository/docker/cschranz/gpu-jupyter):
    ```bash
    git clone https://github.com/iot-salzburg/gpu-jupyter.git
    cd gpu-jupyter
    ```

## Quickstart

First of all, it is necessary to generate the `Dockerfile` based on the latest toolstack of 
[hub.docker.com/u/jupyter](https://hub.docker.com/u/jupyter).
As soon as you have access to your GPU locally (it can be tested via a Tensorflow or PyTorch 
directly on the host node), you can run these commands to start the jupyter notebook via 
docker-compose (internally):

  ```bash
  ./generate_Dockerfile.sh
  docker build -t gpu-jupyter .build/
  docker run -d -p [port]:8888 gpu-jupyter
  ``` 

Alternatively, you can configure the environment in `docker-compose.yml` and run 
this to deploy the `GPU-Jupyter` via docker-compose (under-the-hood):

  ```bash
  ./generate_Dockerfile.sh
  ./start-local.sh -p 8888  # where -p stands for the port of the service
  ```
  
Both options will run *GPU-Jupyter* by default on [localhost:8888](http://localhost:8888) with the default 
password `asdf`.


## Tracing
  
With these commands we can see if everything worked well:
```bash
docker ps
docker logs [service-name]
```

In order to stop the local deployment, run:

  ```bash
  ./stop-local.sh
  ```
 
 
 ## Deployment in the Docker Swarm
 
A Jupyter instance often requires data from other services. 
If that data-source is containerized in Docker and sharing a port for communication shouldn't be allowed, e.g., for security reasons,
then connecting the data-source with *GPU-Jupyter* within a Docker Swarm is a great option! 

### Set up Docker Swarm and Registry

This step requires a running [Docker Swarm](https://www.youtube.com/watch?v=x843GyFRIIY) on a cluster or at least on this node.
In order to register custom images in a local Docker Swarm cluster, 
a registry instance must be deployed in advance.
Note that the we are using the port 5001, as many services use the default port 5000.

```bash
sudo docker service create --name registry --publish published=5001,target=5000 registry:2
curl 127.0.0.1:5001/v2/
```
This should output `{}`. \

Afterwards, check if the registry service is available using `docker service ls`.


### Configure the shared Docker network

Additionally, *GPU-Jupyter* is connected to the data-source via the same *docker-network*. Therefore, This network must be set to **attachable** in the source's `docker-compose.yml`:

```yml
services:
  data-source-service:
  ...
      networks:
      - default
      - datastack
  ...
networks:
  datastack:
    driver: overlay
    attachable: true  
```
 In this example, 
 * the docker stack was deployed in Docker swarm with the name **elk** (`docker stack deploy ... elk`),
 * the docker network has the name **datastack** within the `docker-compose.yml` file,
 * this network is configured to be attachable in the `docker-compose.yml` file
 * and the docker network has the name **elk_datastack**, see the following output:
    ```bash
    sudo docker network ls
    # ...
    # [UID]        elk_datastack                   overlay             swarm
    # ...
    ```
  The docker network name **elk_datastack** is used in the next step as a parameter.
   
### Start GPU-Jupyter in Docker Swarm

Finally, *GPU-Jupyter* can be deployed in the Docker Swarm with the shared network, using:

```bash
./generate_Dockerfile.sh
./add-to-swarm.sh -p [port] -n [docker-network] -r [registry-port]
# e.g. ./add-to-swarm.sh -p 8848 -n elk_datastack -r 5001
```
where:
* **-p:** port specifies the port on which the service will be available.
* **-n:** docker-network is the name of the attachable network from the previous step, e.g., here it is **elk_datastack**.
* **-r:** registry port is the port that is published by the registry service, see [Set up Docker Swarm and Registry](set-up-docker-swarm-and-registry).

Now, *gpu-jupyter* will be accessable here on [localhost:8848](http://localhost:8848) with the default password `asdf` and shares the network with the other data-source, i.e., all ports of the data-source will be accessable within *GPU-Jupyter*, even if they aren't routed it the source's `docker-compose` file.

Check if everything works well using:
```bash
sudo docker service ps gpu_gpu-jupyter
docker service ps gpu_gpu-jupyter
```

In order to remove the service from the swarm, use:
```bash
./remove-from-swarm.sh
```

## Configuration

Please set a new password using `src/jupyter_notebook_config.json`.
Therefore, hash your password in the form (password)(salt) using a sha1 hash generator, e.g., the sha1 generator of [sha1-online.com](http://www.sha1-online.com/). 
The input with the default password `asdf` is appended by a arbitrary salt `e49e73b0eb0e` to `asdfe49e73b0eb0e` and should yield the hash string as shown in the config below.
**Never give away your own unhashed password!**

Then update the config file as shown below and restart the service.

```json
{
  "NotebookApp": {
    "password": "sha1:e49e73b0eb0e:32edae7a5fd119045e699a0bd04f90819ca90cd6"
  }
}
```

### Updates
 
#### Update CUDA to another version

Please check version compatibilities for [CUDA and Pytorch](https://pytorch.org/get-started/locally/)
 respectively [CUDA and Tensorflow](https://www.tensorflow.org/install/gpu) previously. 
To update CUDA to another version, change in `Dockerfile.header`
the line:

    FROM nvidia/cuda:10.1-base-ubuntu18.04
    
and in the `Dockerfile.pytorch` the line:

    cudatoolkit=10.1

Then re-generate and re-run the image, as closer described above:

```bash
./generate_Dockerfile.sh
./start-local.sh -p [port]:8888  
```

#### Update Docker-Stack

The [docker-stacks](https://github.com/jupyter/docker-stacks) are used as  a
submodule within `.build/docker-stacks`. Per default, the head of the commit is reset to a commit on which `gpu-jupyter` runs stable. 
To update the generated Dockerfile to a specific commit, run:

```bash
./generate_Dockerfile.sh --commit c1c32938438151c7e2a22b5aa338caba2ec01da2
```

To update the generated Dockerfile to the latest commit, run:

```bash
./generate_Dockerfile.sh --commit latest
```

A new build can last some time and may consume a lot of data traffic. Note, that the latest version may result in
a version conflict!
More info to submodules can be found in
 [this tutorial](https://www.vogella.com/tutorials/GitSubmodules/article.html).


## Issues and Contributing

This project has the intention to create a robust image for CUDA-based GPU-applications, which is built on top of the [docker-stacks](https://github.com/jupyter/docker-stacks). You are free to help to improve this project, by:

* [filing a new issue](https://github.com/iot-salzburg/gpu-jupyter/issues/new)
* [open a pull request](https://help.github.com/articles/using-pull-requests/)
