# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Update package lists and install necessary packages
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    zlib1g-dev \
    python2 \
    cmake \
    unzip \
    python-pip

COPY llvm-5.0.0.src.tar.xz /llvm-5.0.0.src.tar.xz
COPY cfe-5.0.0.src.tar.xz /cfe-5.0.0.src.tar.xz
COPY z3-4.5.0.zip /z3-4.5.0.zip

# Download LLVM 5.0.0 source and extract
RUN tar xf llvm-5.0.0.src.tar.xz && \
    rm llvm-5.0.0.src.tar.xz

# Download Clang 5.0.0 source and extract
RUN tar xf cfe-5.0.0.src.tar.xz && \
    mv cfe-5.0.0.src clang && \
    rm cfe-5.0.0.src.tar.xz

# Download Z3 4.5.0 source and extract
RUN unzip z3-4.5.0.zip && \
    rm z3-4.5.0.zip

# Copy the LLVM patch into the container 
COPY llvm-5.diff /llvm-5.diff

# Change working directory to llvm source
WORKDIR /llvm-5.0.0.src

# need to patch https://bugs.gentoo.org/attachment.cgi?id=538578&action=diff
RUN patch -p1 < /llvm-5.diff

# Create build directory for LLVM
RUN mkdir build

# Change working directory to LLVM build directory, 
WORKDIR /llvm-5.0.0.src/build

# Configure LLVM build
RUN cmake -G "Unix Makefiles" -DLLVM_ENABLE_PROJECTS=clang -DCMAKE_BUILD_TYPE=release ..

# Build LLVM
RUN make -j`nproc`

# Install LLVM
RUN make -j`nproc` install

# Change working directory to Z3 source
WORKDIR /z3-z3-4.5.0

# Generate Z3 makefiles
RUN python2 scripts/mk_make.py --python

# Change working directory to Z3 build directory
WORKDIR /z3-z3-4.5.0/build

# Build Z3
RUN make -j`nproc`

# Install Z3
RUN make -j`nproc` install

# Free space
RUN apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set back to root directory
WORKDIR /