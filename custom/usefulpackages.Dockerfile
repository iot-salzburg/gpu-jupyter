LABEL authors="Christoph Schranz <christoph.schranz@salzburgresearch.at>, Mathematical Michael <consistentbayes@gmail.com>"

USER root

# Install useful packages and Graphviz
RUN apt-get update \
 && apt-get -y install --no-install-recommends htop apt-utils iputils-ping graphviz libgraphviz-dev openssh-client \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

USER $NB_UID
RUN set -ex \
 && buildDeps=' \
    graphviz==0.19.1 \
    pytest==7.2.2 \
' \
 && pip install --no-cache-dir $buildDeps \
 && fix-permissions "${CONDA_DIR}" \
 && fix-permissions "/home/${NB_USER}"

# upgrade jupyter-server for compatibility
RUN pip install --no-cache-dir --upgrade \
    distributed==2023.3.0 \
    jupyter-server==2.4 \
    # fix permissions of conda
 && fix-permissions "${CONDA_DIR}" \
 && fix-permissions "/home/${NB_USER}"

RUN pip install --no-cache-dir \
    # install extension manager
    jupyter_contrib_nbextensions==0.7.0 \
    jupyter_nbextensions_configurator==0.6.1 \
    # install git extension
    jupyterlab-git==0.41.0 \
    # install plotly extension
    plotly==5.13.1 \
    # install drawio and graphical extensions
    jupyterlab-drawio==0.9.0 \
    rise==5.7.1 \
    ipyleaflet==0.17.2 \
    ipywidgets==8.0.4 \
    # install spell checker
    jupyterlab-spellchecker==0.7.3 && \
    # fix permissions of conda
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID
