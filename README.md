# GPU-Jupyter

<img src="https://raw.githubusercontent.com/iot-salzburg/gpu-jupyter/master/extra/logo_gupyter.png"
     alt="GPU-Jupyter"
     width=661/>

#### GPU-Jupyter: Your GPU-accelerated JupyterLab with PyTorch, TensorFlow, and a rich data science toolstack for your reproducible deep learning experiments.
 
<!--![Github Workflow](https://github.com/iot-salzburg/gpu-jupyter/actions/workflows/default.yml/badge.svg) Remove as the workflow can't be finished to to No space left on device error-->
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/iot-salzburg/gpu-jupyter/graphs/commit-activity)
[![GitHub pull-requests closed](https://badgen.net/github/closed-prs/iot-salzburg/gpu-jupyter)](https://github.com/iot-salzburg/gpu-jupyter/pulls?q=is%3Aclosed)
[![GitHub commits](https://badgen.net/github/commits/iot-salzburg/gpu-jupyter)](https://GitHub.com/iot-salzburg/gpu-jupyter/commit/)
[![GitHub forks](https://badgen.net/github/forks/iot-salzburg/gpu-jupyter/)](https://GitHub.com/iot-salzburg/gpu-jupyter/stargazers/)
[![Docker Pulls](https://badgen.net/docker/pulls/cschranz/gpu-jupyter?icon=docker&label=Pulls)](https://hub.docker.com/r/cschranz/gpu-jupyter)
[![Docker Stars](https://badgen.net/docker/stars/cschranz/gpu-jupyter?icon=docker&label=Stars)](https://hub.docker.com/r/cschranz/gpu-jupyter)
[![GitHub stars](https://badgen.net/github/stars/iot-salzburg/gpu-jupyter/)](https://GitHub.com/iot-salzburg/gpu-jupyter/network/)


Welcome to this project, which provides a **GPU-capable environment** based on NVIDIA's official CUDA Docker image and the popular [Jupyter's Docker Stacks](https://github.com/jupyter/docker-stacks).
By utilizing version control for the source code, tagged data spaces, seeds for the random functions within isolated Docker containers, our solution **empowers researchers to conduct fully reproducible and sharable machine-learning experiments**.

![GPU-Jupyter Architecture](https://raw.githubusercontent.com/iot-salzburg/gpu-jupyter/refs/heads/master/extra/GPU_Jupyter_arch.png)
Architecture of the GPU-Jupyter Docker image on top of NVIDIA and Docker.

Please find an example of how to **use GPU-Jupyter to make your deep learning research reproducible with one single command on [github.com/iot-salzburg/reproducible-research-with-gpu-jupyter](https://github.com/iot-salzburg/reproducible-research-with-gpu-jupyter)**.


## Contents

1. [Quickstart](#quickstart)
2. [Configuration](#configuration)
2. [Build Your image](#build-your-image)
6. [Issues and Contributing](#issues-and-contributing)



## Quickstart

1. **Requirements:**

   - **NVIDIA GPU with drivers**
   - **CUDA**
   - **Docker**
   - **NVIDIA Container Toolkit**
    
    You can confirm that all requirements are matched if the Docker command below returns a result similar to this one:

    ```bash
    docker run --rm --gpus all nvidia/cuda:12.9.1-cudnn-runtime-ubuntu24.04 nvidia-smi
    ```
    ```bash
    ...
    CUDA Version 12.9.1
    ...
    Thu Jan  8 11:33:16 2026       
    +-----------------------------------------------------------------------------------------+
    | NVIDIA-SMI 580.105.08             Driver Version: 580.105.08     CUDA Version: 13.0     |
    +-----------------------------------------+------------------------+----------------------+
    | GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
    | Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
    |                                         |                        |               MIG M. |
    |=========================================+========================+======================|
    |   0  NVIDIA RTX A6000               On  |   00000000:61:00.0 Off |                  Off |
    | 38%   67C    P0            107W /  300W |       1MiB /  49140MiB |      0%      Default |
    |                                         |                        |                  N/A |
    +-----------------------------------------+------------------------+----------------------+
    
    +-----------------------------------------------------------------------------------------+
    | Processes:                                                                              |
    |  GPU   GI   CI              PID   Type   Process name                        GPU Memory |
    |        ID   ID                                                               Usage      |
    |=========================================================================================|
    |  No running processes found                                                             |
    +-----------------------------------------------------------------------------------------+
    ```

   If your computer doesn't have an NVIDIA GPU, you can get a cloud solution, e.g., using [Saturn Cloud](https://saturncloud.io/?utm_source=Github+&utm_Github=TDS&utm_campaign=ChristophSchranz&utm_term=GPUJupyter).
   **To install the NVIDIA drivers, CUDA, Docker, and the NVIDIA Container Toolkit, follow the [installation script](https://github.com/iot-salzburg/gpu-jupyter/blob/master/extra/README-installations.md) or the guide in this [Medium article: Set up Your own GPU-based Jupyter easily using Docker](https://medium.com/@christoph.schranz/set-up-your-own-gpu-based-jupyterlab-e0d45fcacf43)**.



3. **Pull and run the GPU-Jupyter image:**

   This may take some time as the whole environment for data science will be downloaded:

   
   ```bash
   cd your-working-directory
   ll data  # this path will be mounted by default
   docker run --gpus all -it -p 8848:8888 -v $(pwd)/data:/home/jovyan/work -e GRANT_SUDO=yes -e JUPYTER_ENABLE_LAB=yes --user root cschranz/gpu-jupyter:v1.10_cuda-12.9_ubuntu-24.04
   ```
   ---
   This starts a Docker container of **GPU-Jupyter** with the version `v1.10_cuda-12.9_ubuntu-24.04` locally at [http://localhost:8848](http://localhost:8848) on port `8848`.
   Log in with the token that is displayed in the output (here `5b96bb15be315ccb24643ea368a52cc0ba13657fbc29e409`):
   ```bash
   docker exec -it [container-ID/name] jupyter server list
   # [JupyterServerListApp] Currently running servers:
   # [JupyterServerListApp] http://791003a731e1:8888/?token=5b96bb15be315ccb24643ea368a52cc0ba13657fbc29e409 :: /home/jovyan
   ```

    ![Jupyterlab Overview](https://raw.githubusercontent.com/iot-salzburg/gpu-jupyter/master/extra/jupyterlab-overview.png)
    
    Within JupyterLab, you can access your GPU using `nvidia-smi`.
    Install custom packages on top of the built image with `apt` (run `sudo apt update` before).
    To help you get started with using the GPU, the repository includes some sample code located in `extra/Getting_Started`.
    If you're new to JupyterLab or want to learn more about its features,
    we recommend checking out this [Jupyter Tutorial](https://www.youtube.com/watch?v=A5YyoCKxEOU).




## Configuration

### Docker parameters

Customize the container using the following Docker parameters:

- **`--gpus all`**: Grants the container access to all available GPUs on the host system, enabling GPU acceleration for deep learning workloads.
- **`-it`**: Runs the container in **interactive mode**, allowing direct user interaction via a terminal (useful for executing commands inside the container).
- **`-d`**: Run Docker container in detached mode.
- **`-p 8848:8888`**: Maps **port 8888** of the container to **port 8848** on the host, enabling access to JupyterLab through `http://localhost:8848`.
- **`-v $(pwd):/home/jovyan/work`**: Mounts the current directory (`$(pwd)`) on the host to `/home/jovyan/work` inside the container, ensuring persistent access to files and code across sessions.
- **`-e GRANT_SUDO=yes`**: Grants the Jupyter user (`jovyan`) sudo privileges inside the container, allowing administrative commands if needed.
- **`-e JUPYTER_ENABLE_LAB=yes`**: Ensures JupyterLab (instead of the classic Jupyter Notebook interface) is enabled when the container starts.
- **`-e NB_UID=$(id -u) -e NB_GID=$(id -g)`**: Sets the **user ID (UID) and group ID (GID)** inside the container to match the host system’s user, preventing permission issues when accessing mounted files.
- **`--user root`**: This is the default configuration for running Jupyter within containers, allowing unrestricted access to system configurations and software installations in the isolated environment.
- **`--restart: unless-stopped`**: Restart policy of the container, e.g., at host restart.
- **`cschranz/gpu-jupyter:v1.10_cuda-12.9_ubuntu-24.04`**: Specifies the version of GPU-Jupyter, see the following section for available GPU-Jupyter images. It is strongly recommended to tag the version for the reproducibility of your experiments.

    <details>
    <summary><font color=blue>The most important Docker commands</font></summary>
    
    With these commands we can investigate the container:
    
    ```bash
    docker ps  # use the flat '-a' to view all
    docker stats
    docker logs [service-name | UID] -f  # view the logs
    docker exec -it [service-name | UID] bash  # open bash in the container
    docker rm -f [service-name | UID]  # stop container
    ```
    </details>



### Available GPU-Jupyter Images

All pre-built images are available on [Dockerhub](https://hub.docker.com/r/cschranz/gpu-jupyter). Here are the latest:

 - `v1.10_cuda-12.9_ubuntu-24.04` (full image, see package [README-versions](https://github.com/iot-salzburg/gpu-jupyter/blob/master/extra/README-versions.md))
 - `v1.10_cuda-12.9_ubuntu-24.04` (only with a python interpreter and without Julia and R)
 - `v1.10_cuda-12.9_ubuntu-24.04` (only with a python interpreter and without additional packages)
 - `v1.9_cuda-12.6_ubuntu-24.04` (full image, see package [README-versions](https://github.com/iot-salzburg/gpu-jupyter/blob/master/extra/README-versions.md))
 - `v1.9_cuda-12.6_ubuntu-24.04_python-only` (only with a python interpreter and without Julia and R)
 - `v1.9_cuda-12.6_ubuntu-24.04_slim` (only with a python interpreter and without additional packages)


<details>
<summary><font color=blue> Older images</font></summary>

 - `v1.8_cuda-12.5_ubuntu-22.04` (full image, see package [README-versions](https://github.com/iot-salzburg/gpu-jupyter/blob/master/extra/README-versions.md))
 - `v1.8_cuda-12.5_ubuntu-22.04_python-only` (only with a python interpreter and without Julia and R)
 - `v1.8_cuda-12.5_ubuntu-22.04_slim` (only with a python interpreter and without additional packages)
 - `v1.7_cuda-12.3_ubuntu-22.04` (full image)
 - `v1.7_cuda-12.3_ubuntu-22.04_python-only` (only with a python interpreter and without Julia and R)
 - `v1.7_cuda-12.3_ubuntu-22.04_slim` (only with a python interpreter and without additional packages)
 - `v1.6_cuda-12.0_ubuntu-22.04` (full image)
 - `v1.6_cuda-12.0_ubuntu-22.04_python-only` (only with a python interpreter and without Julia and R)
 - `v1.6_cuda-12.0_ubuntu-22.04_slim` (only with a python interpreter and without additional packages)
 - `v1.6_cuda-11.8_ubuntu-22.04` (full image)
 - `v1.6_cuda-11.8_ubuntu-22.04_python-only` (only with a python interpreter and without Julia and R)
 - `v1.6_cuda-11.8_ubuntu-22.04_slim` (only with a python interpreter and without additional packages)
- `v1.5_cuda-12.0_ubuntu-22.04` (full image)
- `v1.5_cuda-12.0_ubuntu-22.04_python-only` (only with a python interpreter and without Julia and R)
- `v1.5_cuda-12.0_ubuntu-22.04_slim` (only with a python interpreter and without additional packages)
- `v1.5_cuda-11.8_ubuntu-22.04` (full image)
- `v1.5_cuda-11.8_ubuntu-22.04_python-only` (only with a python interpreter and without Julia and R)
- `v1.5_cuda-11.8_ubuntu-22.04_slim` (only with a python interpreter and without additional packages)
- `v1.5_cuda-11.6_ubuntu-20.04` (full image)
- `v1.5_cuda-11.6_ubuntu-20.04_python-only` (only with a python interpreter and without Julia and R)
- `v1.5_cuda-11.6_ubuntu-20.04_slim` (only with a python interpreter and without additional packages)
- `v1.4_cuda-11.6_ubuntu-20.04` (full image)
- `v1.4_cuda-11.6_ubuntu-20.04_python-only` (only with a python interpreter and without Julia and R)
- `v1.4_cuda-11.6_ubuntu-20.04_slim` (only with a python interpreter and without additional packages)
- `v1.4_cuda-11.2_ubuntu-20.04` (full image)
- `v1.4_cuda-11.2_ubuntu-20.04_python-only` (only with a python interpreter and without Julia and R)
- `v1.4_cuda-11.2_ubuntu-20.04_slim` (only with a python interpreter and without additional packages)
- `v1.4_cuda-11.0_ubuntu-20.04` (full image)
- `v1.4_cuda-11.0_ubuntu-20.04_python-only` (only with a python interpreter and without Julia and R)
- `v1.4_cuda-11.0_ubuntu-20.04_slim` (only with a python interpreter and without additional packages)
- `v1.4_cuda-11.0_ubuntu-18.04` (full image)
- `v1.4_cuda-11.0_ubuntu-18.04_python-only` (only with a python interpreter and without Julia and R)
- `v1.4_cuda-11.0_ubuntu-18.04_slim` (only with a python interpreter and without additional packages)
- `v1.4_cuda-10.1_ubuntu-18.04` (full image)
- `v1.4_cuda-10.1_ubuntu-18.04_python-only` (only with a python interpreter and without Julia and R)
- `v1.4_cuda-10.1_ubuntu-18.04_slim` (only with a python interpreter and without additional packages)
</details>

The version number, e.g. `v1.10`, declares the version of the generator setup and is directly linked to a commit hash of the [Jupyter Docker Stacks](https://github.com/jupyter/docker-stacks).
See the installed package versions, including (Python, Julia, R, PyTorch, and TensorFlow) under [README-Versions](#extra/README-versions.md). 
The Cuda version, e.g. `cuda-12.9`, must be supported by the installed NVIDIA driver version on the host. Note that the images built for Ubuntu 20.04 LTS or Ubuntu 22.04 LTS also work on Ubuntu 24.04 LTS. 
In case you are using another version or the GPU libraries don't work on your hardware, please try to build the image on your own as described in [Build Your Image](#build-your-image).



### Set a Static Token

Jupyter by default regenerates a new token on each new start.
GPU-Jupyter provides the environment variable `JUPYTER_TOKEN` to set a customized static token.
This option is practicable if the host machine is periodically restarted.
Here, a UUID is used as a token, however, every other token is also possible:

```bash
export JUPYTER_TOKEN=$(uuidgen)
echo $JUPYTER_TOKEN
```

In Docker add the environment variable `-e JUPYTER_TOKEN=${JUPYTER_TOKEN}`:

```bash
docker run --gpus all -d -it -p 8848:8888 -v $(pwd)/data:/home/jovyan/work -e GRANT_SUDO=yes -e JUPYTER_ENABLE_LAB=yes -e NB_UID="$(id -u)" -e NB_GID="$(id -g)" -e JUPYTER_TOKEN=${JUPYTER_TOKEN} --user root --restart always --name gpu-jupyter_1 gpu-jupyter
```

Any token can be requested by calling `jupyter server list` within the container:
```bash
docker exec -it gpu-jupyter_1 jupyter server list
```


### Deploy with Docker Compose

**Docker Compose features a convenient way for container management** through the text-based specification of Docker parameters and advanced resource constraints.
To run **GPU-Jupyter** in `docker-compose`, you can use the `docker-compose.yml` as a basis for your setup.


```bash
docker-compose up -d  # run in detached mode
docker-compose ps  # check status
docker-compose logs -f  # view the logs
docker-compose down  # stop the container
```

It is recommended to use the option `env_file` in docker-compose to load the `JUPYTER_TOKEN` set in a separate `.env`-file:

In `token.env`:
```env
JUPYTER_TOKEN=b5cd1234-3921-4424-90b5-47a1566d299a
```

In `docker-compose.yml`:
```yaml
    env_file:
      - token.env
```


### Adaptions for using Tensorboard

Both TensorFlow and PyTorch support [tensorboard](https://www.tensorflow.org/tensorboard/get_started).
This package is already installed in the GPU-packages and can be used with these settings:

1. Forward the port in the docker command using `-p 6006:6006` to access in the browser on [localhost:6006](http://localhost:6006) (only for usage outside of Juypterlab).
2. Starting tensorboad with port binding within a container or Jupyterlab UI. Make sure the parameter `--bind_all` is set.

    ```bash
    docker exec -it [container-name/ID] bash
    root@749eb1a06d60:~# tensorboard --logdir mylogdir --bind_all
    ```
    ```jupyter
    %tensorboard --logdir logs/[logdir] --bind_all
    ```

3. Writing the states and results in the tensorboard log-dir, as described in the tutorials for [TensorFlow](https://www.tensorflow.org/tensorboard/get_started) and [PyTorch](https://pytorch.org/tutorials/recipes/recipes/tensorboard_with_pytorch.html) or in the Getting Started section `data/Getting_Started`.




### Customized installations

GPU-Jupyter is very flexible and allows custom installations even on the OS level.

- `pip install -r requirements.txt`: Install pip-packages specified in the requirements-file.
- `sudo apt install [package]`: Run `sudo apt update` before.

    Install packages in the command line or build specific packages from source.

For the best reproducibility, it is recommended to build on top of the Dockerfile, as described below.

    
### Build own Dockerfile

Build additional layers on top of GPU-Jupyter by creating a new `Dockerfile` for your setup:


```Dockerfile
# This Dockerfile builds the image of the deep learning experiment
FROM cschranz/gpu-jupyter:v1.10_cuda-12.9_ubuntu-24.04
LABEL authors="Your Name <e-mail@example.com>"

# #############################################################
# ################### Custom installations ####################
# #############################################################

# apt install your other packages
USER root
RUN apt-get update && \
    apt-get -y install apt-utils

# Copy requirements.txt and install in pip
ADD requirements.txt .
RUN pip install -r requirements.txt

# #############################################################
# ###################### Set environment ######################
# #############################################################

# fix permissions to avoid files or folders hidden in the container
USER root
RUN chown -R ${NB_USER}:${NB_GID} /home/jovyan/work/

# Switch back to user Jovyan to avoid accidental container runs as root
USER ${NB_UID}
WORKDIR ${HOME}
```

Build your custom GPU-Jupyter Dockerfile and tag it for sharing your reproducible setup seamlessly!

```bash
docker build -t your-dockerhub-username/image-name:tag .
docker push your-dockerhub-username/image-name:tag  # optionally push to Dockerhub
docker run --gpus all --rm -it -p 8849:8888 your-dockerhub-username/image-name:tag
```

Please find an example of how to **use GPU-Jupyter to make your deep learning research reproducible with one single command on [github.com/iot-salzburg/reproducible-research-with-gpu-jupyter](https://github.com/iot-salzburg/reproducible-research-with-gpu-jupyter)**.




## Build Your Image

If you have a specific GPU architecture the recommended option is to build your own Docker image by adapting the  partial Dockerfiles in `custom/` and generating and building a new Dockerfile. To use a custom base image, modify `custom/header.Dockerfile`. To install specific GPU-related libraries, modify `custom/gpulibs.Dockerfile`, and to add specific libraries, append them to `custom/usefulpackages.Dockerfile`.
**Keep in mind that every time a Dockerfile is generated, the file `.build/Dockerfile` is overwritten, so it's best to append custom installations in `custom/usefulpackages.Dockerfile` or `generate-Dockerfile.sh`.**

After making the necessary modifications, regenerate the `Dockerfile` in `/.build`. Once you have confirmed that your GPU is accessible within Docker containers by running `docker run --rm --gpus all nvidia/cuda:12.9.1-cudnn-runtime-ubuntu24.04 nvidia-smi` and seeing the GPU statistics, you can generate, build, and run the Docker image.

```bash
git clone https://github.com/iot-salzburg/gpu-jupyter.git
cd gpu-jupyter
git branch  # Check for existing branches
git checkout v1.10_cuda-12.9_ubuntu-24.04  # select or create a new version
# generate the Dockerfile with Python and without Julia and R (see options: --help)
./generate-Dockerfile.sh --python-only
docker build -t gpu-jupyter .build/ --progress=plain  # will take a while
docker run --rm --gpus all -it -p 8848:8888 -v $(pwd)/data:/home/jovyan/work -e GRANT_SUDO=yes -e JUPYTER_ENABLE_LAB=yes -e NB_UID="$(id -u)" -e NB_GID="$(id -g)" --user root --name gpu-jupyter gpu-jupyter
```

This command starts a container with GPU support and a shared local data volume `/data`, along with other necessary configurations, such as root permissions to install packages within the container. For more configuration options, see [Configuration of the Dockerfile-Generation](#configuration-of-the-dockerfile-generation) below.



### Configuration of the Dockerfile-Generation

To generate a Dockerfile for *GPU-Jupyter*, you can use the script `generate-Dockerfile.sh`. It generates a Dockerfile in the `.build/` directory, which is overwritten with each new generation.

The script has the following parameters:


* `-h|--help`: Show a help message.

* `-p|--pw|--password`: Set the password for *GPU-Jupyter* by updating
 the salted hashed token in `custom/jupyter_notebook_config.json`.

* `-c|--commit`: specify a commit or `"latest"` for the `Jupyter's Docker Stacks`,
the default commit is a working one.

* `-s|--slim`: Generate a slim Dockerfile.
As some installations are not needed by everyone, there is the possibility to skip some
installations to reduce the size of the image.
Here the `scipy-notebook` is used instead of `datascience-notebook`
that comes with Julia and R, see [Jupyter's Docker Stacks](https://github.com/jupyter/docker-stacks).
Moreover, none of the packages within `custom/usefulpackages.Dockerfile` is installed.

* `--python-only|--no-datascience-notebook`: As the name suggests, the `datascience-notebook`
is not installed on top of the `scipy-notebook`, but the packages within `custom/usefulpackages.Dockerfile` are.

* `--no-useful-packages`: On top of the `datascience-notebook` (Julia and R),
the essential `gpulibs` are installed, but not the packages within `custom/usefulpackages.Dockerfile`.

Note that only one of the parameters `--slim`, `--python-only`, and `--no-useful-packages` can be used at the same time:


### Set NVIDIA CUDA Base Image 

The GPU libraries such as PyTorch and Tensorflow in `custom/Docker.gpulibs` must support the CUDA version and NVIDIA drivers on the host machine. Check out the compatibility lists for [PyTorch](https://pytorch.org/get-started/locally/) and [Tensorflow](https://www.tensorflow.org/install/source#gpu) or search online for the explicit versions.

The host's CUDA version must be equal to or higher than that used by the container (set within `custom/header.Dockerfile`).
Check the host's version with `nvcc --version` and the version compatibilities
for CUDA-dependent packages as [Pytorch](https://pytorch.org/get-started/locally/)
 respectively [Tensorflow](https://www.tensorflow.org/install/gpu) previously.
Then modify, if supported, the CUDA-version in the the line `FROM nvidia/cuda:X.Y-base-ubuntu24.04`
in `custom/header.Dockerfile`  (find available tags [here](https://hub.docker.com/r/nvidia/cuda/tags)).



### Specify Jupyter Docker Stacks Version

The [Jupyter's Docker Stacks](https://github.com/jupyter/docker-stacks) is used as a submodule within `.build/docker-stacks`. Per default, the head of the commit is set to a commit on which `gpu-jupyter` runs stable.
To set the docker-stacks to a specific version generate the Dockerfile with a specific [docker-stacks commit](https://github.com/jupyter/docker-stacks/commits/main), run:

```bash
./generate-Dockerfile.sh --commit c1c32938438151c7e2a22b5aa338caba2ec01da2
```

To update the generated Dockerfile to the latest commit, run:

```bash
./generate-Dockerfile.sh --commit latest
```

A new build can last some time and may consume a lot of data traffic. Note, that untested versions can result in
version conflicts.



## Issues and Contributing

### Frequent Issues:

- **Can't save a file within the GPU-Jupyter Container.**
    This issue originates from non-privileged file ownership of a mounted volume.
    Run `sudo chown -R [USER]:[GROUP] /path/to/project/data/`.

- **Can't install packages with apt.**
    Make sure to run `sudo apt update` before.

- **Can't execute the bash scripts.**
    ```bash
    $ bash generate-Dockerfile.sh
    generate-Dockerfile.sh: line 2: cd: $'/path/to/gpu-jupyter\r': No such file or directory
    generate-Dockerfile.sh: line 3: $'\r': command not found
    generate-Dockerfile.sh: line 9: $'\r': command not found
    generate-Dockerfile.sh: line 11: syntax error near unexpected token `$'in\r''
    generate-Dockerfile.sh: line 11: `while [[ "$#" -gt 0 ]]; do case $1 in
    ```
    The reason for this issue is that the line breaks between Unix and Windows-based systems are different and in the current version different.

    **Solution**: Change the line endings of the bash scripts. This can be done e.g. in the *Notepad++* under
    *Edit* - *EOL Conversion*, or using `dos2unix`
    ```bash
    sudo apt install dos2unix
    dos2unix generate-Dockerfile.sh
    ```

- **No GPU available - error**
    The docker-compose start breaks with:
    ```bash
    ERROR: for fc8d8dfbebe9_gpu-jupyter_gpu-jupyter_1  Cannot start service gpu-jupyter: OCI runtime create failed: container_linux.go:370: starting container process caused: process_linux.go:459: container init ca
    used: Running hook #0:: error running hook: exit status 1, stdout: , stderr: nvidia-container-cli: initialization error: driver error: failed to process request: unknown
    ```
    **Solution**:
    Check if the GPU is available on the host node via `nvidia-smi` and run with the described `docker`-commands.
    If the error still occurs, so try there could be an issue that docker can't use the GPU. Please try [this](https://cschranz.medium.com/set-up-your-own-gpu-based-jupyterlab-e0d45fcacf43) or similar tutorials on how to install the required drivers.

- **Some file is not found:**
    ```
    Step 22/64 : COPY --chown="${NB_UID}:${NB_GID}" initial-condarc "${CONDA_DIR}/.condarc"
  COPY failed: file not found in build context or excluded by .dockerignore: stat initial-condarc: file does not exist
  ```
  &rarr; Adapt `generate-Dockerfile.sh` so that it copies `initial-condarc` into the working directory as it does with other files. Renamed files result in a similar issue and solution.

- **The specified package version is not compatible with the drivers.**
    ```
    Step 56/64 : RUN pip install --upgrade pip &&     pip install --no-cache-dir "tensorflow==2.6.2" &&     pip install --no-cache-dir keras
     ---> Running in 7c5701a3d780
    Requirement already satisfied: pip in /opt/conda/lib/python3.10/site-packages (22.1.2)
    ERROR: Could not find a version that satisfies the requirement tensorflow==2.6.2 (from versions: 2.8.0rc0, 2.8.0rc1, 2.8.0, 2.8.1, 2.8.2, 2.9.0rc0, 2.9.0rc1, 2.9.0rc2, 2.9.0, 2.9.1)
    ERROR: No matching distribution found for tensorflow==2.6.2
    ```

    &rarr; Just update the package to a version that is compatible, here tensorflow 2.8.2 was.

- **Branch `master` is not known:**
    ```
    error: pathspec 'master' did not match any file(s) known to git.
    ```
    &rarr; The default branch of [Jupyter's Docker Stacks](https://github.com/jupyter/docker-stacks) were
    renamed from `master` to `main`. Delete the subdirectory `.build/docker-stacks` and regenerate the the Dockerfile.
    General information on submodules can be found in
    [this tutorial](https://www.vogella.com/tutorials/GitSubmodules/article.html).



### Contribution

This project has the intention to create a robust image for CUDA-based GPU applications,
which is built on top of the official NVIDIA CUDA Docker image and [Jupyter's Docker Stacks](https://github.com/jupyter/docker-stacks). A big thank you to [Jupyter's Docker Stacks](https://github.com/jupyter/docker-stacks) for creating and maintaining a robust Python, R, and Julia toolstack for Data Science.

Please help us to improve this project by:

* [filing a new issue](https://github.com/iot-salzburg/gpu-jupyter/issues/new)
* [open a pull request](https://help.github.com/articles/using-pull-requests/)


## Cite This Work

Please cite the GPU-Jupyter framework in your publication when you are using GPU-Jupyter for your academic work:

```
Schranz, C., Pilosov, M., & Beeking, M. (2025). GPU-Jupyter: A Framework for Reproducible Deep Learning Research. In Interdisciplinary Data Science Conference. 10.13140/RG.2.2.15549.99040
```

```apa-style
@inproceedings{GPU-Jupyter2025,
  author = {Schranz, C. and Pilosov, M. and Beeking, M.},
  title = {GPU-Jupyter: A Framework for Reproducible    Deep Learning Research},
  booktitle = {Interdisciplinary Data Science Conference},
  year = {2025},
  publisher = {ResearchGate},
  doi = {10.13140/RG.2.2.15549.99040},
  url = {https://www.researchgate.net/publication/393662057}
}
```