FROM ubuntu:22.04

MAINTAINER Asya Khleborodova <asya.khleborodova@nih.gov>

RUN mkdir -p /data2
RUN mkdir -p /opt2

# Apt-get packages
# Install python (3.10), bowtie2=2.4.4-1 (ubuntu:22.04 default)
RUN apt-get update && apt-get -y upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get install --yes \
    build-essential \
    apt-utils \
    git-all \
    python3 \ 
    python3-pip \
    bowtie2 \
    wget

WORKDIR /opt2

# Build Samtools 1.17, Telescope requires htslib=1.17 (must install SAMtools=1.17)
# SAMtools installation information: https://github.com/samtools/samtools/blob/develop/INSTALL
# HTSlib installation information: https://github.com/samtools/htslib/blob/1.9/INSTALL
# Apt-get remaining dependencies  
RUN DEBIAN_FRONTEND=noninteractive apt-get install --yes \
    gcc \
    make \
    perl \
    bzip2 \
    libssl-dev \
    libbz2-dev \
    zlib1g-dev \
    libncurses5-dev \ 
    libncursesw5-dev \
    libcurl4-gnutls-dev \
    liblzma-dev \
    locales \
    pigz && \
apt-get clean && apt-get purge && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Build SAMtools 1.17
RUN wget https://github.com/samtools/samtools/releases/download/1.17/samtools-1.17.tar.bz2 && \
    tar -xjvf samtools-1.17.tar.bz2 && \
    rm samtools-1.17.tar.bz2 && \
    cd samtools-1.17 && \
    ./configure --prefix $(pwd) && \
    make

# Build HTSlib 1.17 (required by telescope)
RUN wget https://github.com/samtools/htslib/releases/download/1.17/htslib-1.17.tar.bz2 && \
    tar -vxjf htslib-1.17.tar.bz2 && \
    rm htslib-1.17.tar.bz2 && \
    cd htslib-1.17 && \
    ./configure --prefix $(pwd) && \
    make

# Add SAMtools and HTSlib to PATH
ENV PATH=${PATH}:/opt2/samtools-1.17
ENV PATH=${PATH}:/opt2/htslib-1.17
ENV HTSLIB_INCLUDE_DIR="/opt2/htslib-1.17"

# pip install: Cutadapt, Telescope dependencies, and then Telescope
RUN pip3 install --upgrade pip
RUN pip3 install cutadapt==4.3 

# Python requirements from github page some are need for compiling telescope, installing now
RUN pip3 install future pyyaml cython numpy scipy pysam intervaltree pandas
RUN pip3 install git+https://github.com/mlbendall/telescope.git


# Set environment variable(s)
# Configure "locale", see https://github.com/rocker-org/rocker/issues/19
# Adding pigz for cutadapt
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
   && locale-gen en_US.utf8 \
   && /usr/sbin/update-locale LANG=en_US.UTF-8


# Copy the Dockerfile used to create image in /opt2
COPY Dockerfile /opt2
WORKDIR /data2