# Base image for sc_te,
# uses Ubuntu Jammy (LTS)
FROM ubuntu:22.04

############# OVERVIEW #############
#  • python+pip3/3.10 (apt-get python3)
#  • scTE
#  • samtools, bedtools
LABEL maintainer="Asya Khleborodova <asya.khleborodova@nih.gov>" \
    base_image="ubuntu:22.04" \
    version="v0.1.0"   \
    software="ervx" \
    about.summary="scTE for ervx pipeline" \
    about.home="https://github.com/OpenOmics/ervx" \
    about.documentation="https://openomics.github.io/ervx/" \
    about.tags="Characterization of endogenous retrovirus"

############### INIT ################
# Create Container filesystem specific 
# working directory and opt directories
# to avoid collisions with host filesystem 
RUN mkdir -p /data2
RUN mkdir -p /opt2

WORKDIR /opt2 

# Set time zone to US east coast 
ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone

############### SETUP ################
# This section installs system packages 
# required for your project. If you need 
# extra system packages add them here.
RUN apt-get update \
    && apt-get -y upgrade \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        apt-transport-https \
        autotools-dev \
        automake \
        autoconf \
        build-essential \
        curl \
        git \
        locales \
        cmake \
        make \
        tabix \
        wget \
        samtools \
        bedtools \
        python3 \
        python3-pip \
    && apt-get clean && apt-get purge \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set the locale
RUN localedef -i en_US -f UTF-8 en_US.UTF-8

############### INSTALL ################

RUN ln -s /usr/bin/python3.10 /usr/bin/python
RUN git clone https://github.com/JiekaiLab/scTE.git \
    && cd scTE \
    && git checkout 36d492127f27ea02d204a28e0f4dea3964818725 \
    && sed -i 's/scipy/&==1.7.3/' setup.py \
    && sed -i 's/numpy/&==1.21.6/' setup.py \
    && python setup.py install
WORKDIR /opt2 

################ POST #################
# Copy the Dockerfile used to create image in /opt2
COPY Dockerfile /opt2
RUN chmod a+x /opt2/scTE/* 
WORKDIR /data2