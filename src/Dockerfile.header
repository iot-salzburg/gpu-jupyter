# Use NVIDIA CUDA as base image and run the same installation as in the other packages.
# The version of cuda must match those of the packages installed in src/Dockerfile.gpulibs
FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04
LABEL authors="Christoph Schranz <christoph.schranz@salzburgresearch.at>, Mathematical Michael <consistentbayes@gmail.com>"
# This is a concatenated Dockerfile, the maintainers of subsequent sections may vary.
RUN chmod 1777 /tmp && chmod 1777 /var/tmp

# install apt-utils in header to fix warnings in docker-stacks
RUN apt-get update && \
    apt-get -y install apt-utils
