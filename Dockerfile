FROM debian:bullseye-slim

ARG DEBIAN_FRONTEND=noninteractive

ENV TZ=Europe/Paris

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    ca-certificates \
    cmake \
    curl \
    git \
    gpg-agent \
    g++ \
    gcc \
    libgl1-mesa-dev \
    libX11-dev \
    freeglut3 freeglut3-dev \
    xorg-dev \
    libeigen3-dev \
    libirrlicht-dev \
    libblas3 \
    liblapack3 \
    libomp-dev \
    libbz2-dev \
    make \
    ninja-build \
    pkg-config \
    python3 \
    python3-dev \
    software-properties-common \
    swig \
    unzip \
    wget \
 && rm -rf /var/lib/apt/lists/*

RUN wget --quiet https://github.com/projectchrono/chrono/archive/refs/tags/8.0.0.tar.gz -O chrono_src.tar.gz && \
    mkdir -p chrono_src && \
    tar -xzf chrono_src.tar.gz --strip 1 -C chrono_src && \
    rm -rf chrono_src.tar.gz && \
    mkdir -p chrono_build && \
    cd chrono_build && \
    cmake \
         -D ENABLE_MODULE_POSTPROCESS:BOOL=ON \
         -D ENABLE_MODULE_IRRLICHT:BOOL=ON \
         -D ENABLE_MODULE_PYTHON:BOOL=ON \
         ../chrono_src && \
    make -j 4 && \
    make install && \ 
    cd .. && \
    rm -rf chrono_src
