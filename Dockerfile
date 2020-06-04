# Container image that runs your code
FROM ubuntu:18.04

# Install prereqs

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    libssl-dev \
    uuid-dev \
    libgpgme11-dev \
    squashfs-tools \
    libseccomp-dev \
    wget \
    pkg-config \
    git \
    cryptsetup \
    python3 \
    python3-pip

# Change working directory
WORKDIR /tmp

# Download and install Go version 1.13

RUN wget https://dl.google.com/go/go1.13.linux-amd64.tar.gz && \ 
    tar -C /usr/local -xzvf go1.13.linux-amd64.tar.gz && \
    rm /tmp/go1.13.linux-amd64.tar.gz

# Download Singularity

RUN wget https://github.com/sylabs/singularity/releases/download/v3.5.2/singularity-3.5.2.tar.gz && \
    tar -xzf singularity-3.5.2.tar.gz

# Update environment to add Go to path
ENV PATH=/usr/local/go/bin:$PATH

# Install Singularity
RUN cd /tmp/singularity && ./mconfig && \
    make -C builddir && \
    make -C builddir install

# Install hpccm
RUN pip3 install hpccm

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]

