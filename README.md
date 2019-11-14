# gpu-jupyter
#### Leverage the power of Jupyter and use your NVIDEA GPU and use Tensorflow and Pytorch in collaborative notebooks. 


## Contents

1. [Requirements](#requirements)
2. [Quickstart](#quickstart)
3. [Deployment](#deployment-in-the-docker-swarm)
3. [Configuration](#configuration)
4. [Trouble-Shooting](#trouble-shooting)


## Requirements

1.  Install [Docker](https://www.docker.com/community-edition#/download) version **1.10.0+**
2.  Install [Docker Compose](https://docs.docker.com/compose/install/) version **1.6.0+**

3.  Get access to use your GPU via the CUDA drivers, see this [blog-post](https://medium.com/@christoph.schranz)
4.  Clone this repository
    ```bash
    git clone https://github.com/iot-salzburg/gpu-jupyter.git
    cd gpu-jupyter
    ```

## Quickstart

As soon as you have access to your GPU locally (it can be tested via a Tensorflow or PyTorch), you can run these commands to start the jupyter notebook via docker-compose:
  ```bash
  ./start-local.sh
  ```
  
This will run jupyter on the default port [localhost:8888](localhost:8888). The general usage is:
  ```bash
  ./start-local.sh -p [port]  # port must be an integer with 4 or more digits.
  ```
In order to stop the local deployment, run:

  ```bash
  ./stop-local.sh
  ```
 
  
