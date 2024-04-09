LABEL authors="Christoph Schranz <christoph.schranz@salzburgresearch.at>, Mathematical Michael <consistentbayes@gmail.com>"

USER root

# Install useful packages and Graphviz
RUN apt-get update \
 && apt-get -y install --no-install-recommends htop apt-utils iputils-ping graphviz libgraphviz-dev openssh-client \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

USER $NB_UID
RUN set -ex \
 && buildDeps=' \
    graphviz==0.20.3 \
    pytest==8.1.1 \
 ' \
 && pip install --no-cache-dir $buildDeps \
 && fix-permissions "${CONDA_DIR}" \
 && fix-permissions "/home/${NB_USER}"

# upgrade jupyter-server for compatibility
RUN set -ex \
 && buildDeps=' \
    distributed==2024.4.1 \
    jupyter-server==2.13 \
 ' \
 && pip install --no-cache-dir $buildDeps \
 && fix-permissions "${CONDA_DIR}" \
 && fix-permissions "/home/${NB_USER}"

RUN set -ex \
 && buildDeps=' \
    # install extension manager
    jupyter_contrib_nbextensions==0.7.0 \
    jupyter_nbextensions_configurator==0.6.3 \
    # install git extension
    jupyterlab-git==0.50.0 \
    # install plotly extension
    plotly==5.20.0 \
    # install drawio and graphical extensions, not compatible with Jupyterlab 4.X yet
    # ipydrawio==1.3.0 \
    ipyleaflet==0.18.2 \
    ipywidgets==8.1.2 \
    # install spell checker
    jupyterlab-spellchecker==0.8.4 \
    ' \
    && pip install --no-cache-dir $buildDeps \
    && fix-permissions "${CONDA_DIR}" \
    && fix-permissions "/home/${NB_USER}"

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID
