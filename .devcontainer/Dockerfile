FROM ://microsoft.com

# Install system dependencies required for compiling and running raylib
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
       build-essential \
       cmake \
       git \
       libasound2-dev \
       libmesa-dev \
       libglu1-mesa-dev \
       libx11-dev \
       libxrandr-dev \
       libxi-dev \
       libxinerama-dev \
       libxcursor-dev \
       libxkbcommon-dev