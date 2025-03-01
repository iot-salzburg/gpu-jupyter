LABEL authors="Christoph Schranz <christoph.schranz@salzburgresearch.at>"

# Install dependencies for e.g. PyTorch
RUN mamba install --quiet --yes \
    pyyaml setuptools cmake cffi typing && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Install Tensorflow, check compatibility here:
# https://www.tensorflow.org/install/source#gpu
# installation via conda leads to errors in version 4.8.2
# Install CUDA-specific nvidia libraries and update libcudnn8 before that
# using device_lib.list_local_devices() the cudNN version is shown, adapt version to tested compat
USER ${NB_UID}
RUN pip install --upgrade pip && \
    pip install --no-cache-dir tensorflow==2.18.0 keras==3.8.0 && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Check compatibility here:
# https://pytorch.org/get-started/locally/
# Installation via conda leads to errors installing cudatoolkit=11.1
# RUN pip install --no-cache-dir torch==2.2.2 torchvision==0.17.2 torchaudio==2.2.2 \
#  && torchviz==0.0.2 --extra-index-url https://download.pytorch.org/whl/cu121
RUN set -ex \
 && buildDeps=' \
    torch==2.6.0 \
    torchvision==0.21.0 \
    torchaudio==2.6.0 \
' \
 && pip install --no-cache-dir $buildDeps  --index-url https://download.pytorch.org/whl/cu126\
 && fix-permissions "${CONDA_DIR}" \
 && fix-permissions "/home/${NB_USER}"

USER root
ENV CUDA_PATH=/opt/conda/

# Install nvtop to monitor the gpu tasks
RUN apt-get update && \
    apt-get install -y --no-install-recommends cmake libncurses5-dev libncursesw5-dev git && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# reinstall nvcc with cuda-nvcc to install ptax
USER $NB_UID
# These need to be two separate pip install commands, otherwise it will throw an error
# attempting to resolve the nvidia-cuda-nvcc package at the same time as nvidia-pyindex
RUN pip install --no-cache-dir nvidia-pyindex && \
    pip install --no-cache-dir nvidia-cuda-nvcc && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Install cuda-nvcc with sepecific version, see here:
# https://anaconda.org/nvidia/cuda-nvcc/labels
RUN mamba install -c nvidia cuda-nvcc=12.6.85 -y && \
    mamba clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

USER root
RUN ln -s $CONDA_DIR/bin/ptxas /usr/bin/ptxas

USER $NB_UID
