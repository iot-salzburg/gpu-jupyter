LABEL maintainer="Christoph Schranz <christoph.schranz@salzburgresearch.at>, Mathematical Michael <consistentbayes@gmail.com>"

# Install dependencies for e.g. PyTorch
RUN mamba install --quiet --yes \
        cffi \
        cmake \
        pyyaml \
        setuptools \
        typing && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Check compatibility here:
# https://pytorch.org/get-started/locally/
# Installation via conda leads to errors installing cudatoolkit=11.1
# RUN pip install --no-cache-dir torch==2.2.2 torchvision==0.17.2 torchaudio==2.2.2 \
#  && torchviz==0.0.2 --extra-index-url https://download.pytorch.org/whl/cu121
RUN set -ex &&  \
    pip install --no-cache-dir --extra-index-url https://download.pytorch.org/whl/nightly/cu124 \
        torch==2.3.1 \
        torchaudio==2.3.1 \
        torchvision==0.18.1 && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

USER root
ENV CUDA_PATH=/opt/conda/

# Install nvtop to monitor the gpu tasks
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        cmake \
        ffmpeg \
        git \
        libncurses5-dev \
        libncursesw5-dev \
        libopenmpi-dev \
        openmpi-bin && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install dependencies for e.g. PyTorch
RUN mamba install --quiet --yes \
        mpi4py && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# reinstall nvcc with cuda-nvcc to install ptax
USER $NB_UID
# These need to be two separate pip install commands, otherwise it will throw an error
# attempting to resolve the nvidia-cuda-nvcc package at the same time as nvidia-pyindex
RUN pip install --no-cache-dir nvidia-pyindex && \
    pip install --no-cache-dir \
        nvidia-cuda-nvcc \
        nvidia-cudnn-cu12==9.2.1.18 && \
    pip install --no-cache-dir --pre --extra-index-url https://pypi.nvidia.com \
        tensorrt_llm && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Install cuda-nvcc with sepecific version, see here: https://anaconda.org/nvidia/cuda-nvcc/labels
RUN mamba install -c nvidia \
        cuda-nvcc=12.4.131 -y && \
    mamba clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

USER root
RUN ln -s $CONDA_DIR/bin/ptxas /usr/bin/ptxas

USER $NB_UID
