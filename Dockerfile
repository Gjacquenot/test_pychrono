FROM debian:bullseye-slim AS builder

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
    libx11-dev \
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
         -D CMAKE_INSTALL_PREFIX=/usr/local/chrono \
         -D ENABLE_MODULE_POSTPROCESS:BOOL=ON \
         -D ENABLE_MODULE_IRRLICHT:BOOL=ON \
         -D ENABLE_MODULE_PYTHON:BOOL=ON \
         ../chrono_src && \
    make -j 4 && \
    make install && \ 
    cd .. && \
    rm -rf chrono_src

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    python3-six \
    python3-numpy \
    python3-matplotlib \
 && rm -rf /var/lib/apt/lists/*

RUN ldd /usr/local/chrono/lib/libChronoEngine.so || true
RUN ldd /usr/local/chrono/share/chrono/python/_core.so || true
RUN export LD_LIBRARY_PATH="/usr/local/chrono/lib:$LD_LIBRARY_PATH" \
 && export PYTHONPATH="/usr/local/chrono/share/chrono/python:/usr/local/chrono/lib:$PYTHONPATH" \
 && python3 /usr/local/chrono/share/chrono/python/pychrono/demos/core/demo_CH_buildsystem.py 

#RUN export PYTHONPATH="/usr/local/chrono/share/chrono/python:/usr/local/chrono/lib:$PYTHONPATH" && \
#    export DISPLAY="unix:0" && \
#    python3 /usr/local/share/chrono/python/pychrono/demos/mbs/demo_MBS_custom_contact.py

FROM deepnote/python:3.9-bullseye

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    libgl1-mesa-dev \
    libx11-dev \
    freeglut3 \
    xorg-dev \
    libirrlicht1.8 \
    libomp5 \
    python3-six \
    python3-numpy \
    python3-matplotlib \
 && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/chrono /usr/local/chrono

RUN ldd /usr/local/chrono/lib/libChronoEngine.so || true
RUN ldd /usr/local/chrono/share/chrono/python/_core.so || true
RUN export LD_LIBRARY_PATH="/usr/local/chrono/lib:$LD_LIBRARY_PATH" \
 && export PYTHONPATH="/usr/local/chrono/share/chrono/python:/usr/local/chrono/lib:$PYTHONPATH" \
 && python3 /usr/local/chrono/share/chrono/python/pychrono/demos/core/demo_CH_buildsystem.py 
