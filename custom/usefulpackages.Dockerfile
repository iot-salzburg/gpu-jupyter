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

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID
