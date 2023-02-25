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
    libeigen3-dev \
    libirrlicht-dev \
    libblas3 \
    liblapack3 \
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
