LABEL authors="Christoph Schranz <christoph.schranz@salzburgresearch.at>"

USER root

# Install useful packages and Graphviz
RUN apt-get update \
 && apt-get -y install --no-install-recommends htop apt-utils iputils-ping graphviz libgraphviz-dev openssh-client \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

USER $NB_UID
RUN set -ex \
 && buildDeps=' \
    graphviz==0.21 \
    pytest==9.1.1 \
 ' \
 && pip install --no-cache-dir $buildDeps \
 && fix-permissions "${CONDA_DIR}" \
 && fix-permissions "/home/${NB_USER}"

# upgrade jupyter-server for compatibility
RUN set -ex \
 && buildDeps=' \
    distributed==2026.7.1 \
    jupyter-server==2.20.0 \
 ' \
 && pip install --no-cache-dir $buildDeps \
 && fix-permissions "${CONDA_DIR}" \
 && fix-permissions "/home/${NB_USER}"

RUN set -ex \
 && buildDeps=' \
    # install git extension
    jupyterlab-git==0.54.0 \
    # install plotly extension
    plotly==6.9.0 \
    # don't install drawio and graphical extensions, not compatible with Jupyterlab 4.X yet
    # ipydrawio==1.3.0 \
    ipyleaflet==0.20.0 \
    ipywidgets==8.1.8 \
    # install spell checker
    jupyterlab-spellchecker==0.9.0 \
    # install computer vision library (headless version for server applications)
    opencv-python-headless==5.0.0.93 \
    ' \
    && pip install --no-cache-dir $buildDeps \
    && fix-permissions "${CONDA_DIR}" \
    && fix-permissions "/home/${NB_USER}"

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID
