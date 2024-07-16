LABEL authors="Christoph Schranz <christoph.schranz@salzburgresearch.at>, Mathematical Michael <consistentbayes@gmail.com>"

USER root

# Install useful packages and Graphviz
RUN apt-get update &&  \
    apt-get -y install --no-install-recommends \
        apt-utils \
        curl \
        graphviz \
        htop \
        iputils-ping \
        libgraphviz-dev \
        openssh-client \
        portaudio19-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://ollama.com/install.sh | sh

USER $NB_UID
RUN set -ex && \
    pip install --no-cache-dir \
        graphviz==0.20.3 \
        pytest==8.1.1 && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# upgrade jupyter-server for compatibility
RUN set -ex && \
    pip install --no-cache-dir \
        distributed==2024.4.1 \
        jupyter-server==2.13 && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

RUN set -ex && \
    pip install --no-cache-dir \
        jupyter_contrib_nbextensions==0.7.0 \
        jupyter_nbextensions_configurator==0.6.3 \
        jupyterlab-git==0.50.0 \
        plotly==5.20.0 \
        ipyleaflet==0.18.2 \
        ipywidgets==8.1.2 \
        jupyterlab-spellchecker==0.8.4 && \
    jupyter labextension enable widgetsnbextension && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

RUN git clone --depth 1 https://github.com/NVIDIA/TensorRT-LLM.git && \
    mv TensorRT-LLM/examples/whisper ~/ && \
    rm -rf TensorRT-LLM

# check https://github.com/collabora/WhisperLive/blob/cb392cbb934447ce8021c0eba06ecbd186bdf13d/scripts/build_whisper_tensorrt.sh
# for other whisper models
RUN cd ~/whisper && \
    pip install -r requirements.txt && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}" && \
    wget --directory-prefix=assets https://raw.githubusercontent.com/openai/whisper/main/whisper/assets/multilingual.tiktoken && \
    wget --directory-prefix=assets https://raw.githubusercontent.com/openai/whisper/main/whisper/assets/mel_filters.npz && \
    wget --directory-prefix=assets https://raw.githubusercontent.com/yuekaizhang/Triton-ASR-Client/main/datasets/mini_en/wav/1221-135766-0002.wav

RUN pip install --no-cache-dir \
        ffmpeg-python \
        jiwer \
        onnxruntime \
        tokenizers==0.19.1 \
        websockets \
        websocket-client && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

RUN mamba install -y \
        pyaudio && \
    mamba clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID
