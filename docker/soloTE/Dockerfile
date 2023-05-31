# Base image for solo_te,
# uses Ubuntu Jammy (LTS)
FROM ubuntu:22.04

############# OVERVIEW #############
#  • python+pip3/3.10 (apt-get python3)
#    - pysam
#    - pandas
#  • R/4.2.2
#  • bcftools, samtools
LABEL maintainer="Asya Khleborodova <asya.khleborodova@nih.gov>" \
    base_image="ubuntu:22.04" \
    version="v0.1.0"   \
    software="ervx" \
    about.summary="solo_TE for ervx pipeline" \
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
        software-properties-common \
        dirmngr \
        gcc \
        perl \
        zlib1g-dev \
        libbz2-dev \
        liblzma-dev \
        libcurl4-gnutls-dev \
        libssl-dev \
        libncurses5-dev \
        autotools-dev \
        automake \
        autoconf \
        build-essential \
        bcftools \
        curl \
        git \
        gawk \
        locales \
        cmake \
        make \
        python3 \
        python3-pip \
        tabix \
        bedtools \
        wget \
    && apt-get clean && apt-get purge \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set the locale
RUN localedef -i en_US -f UTF-8 en_US.UTF-8

RUN ln -sf /usr/bin/python3.10 /usr/bin/python

############### INSTALL ################
# Build SAMtools 1.17
RUN wget https://github.com/samtools/samtools/releases/download/1.17/samtools-1.17.tar.bz2 && \
    tar -xjvf samtools-1.17.tar.bz2 && \
    rm samtools-1.17.tar.bz2 && \
    cd samtools-1.17 && \
    ./configure --prefix $(pwd) && \
    make && \
    make install

# Install Python Packages
RUN pip3 install --upgrade pip \
	  && pip3 install pysam pandas

# Install R (4.2) and required packages (none in this case)
# For more information, check out: 
# https://cran.r-project.org/bin/linux/ubuntu/
RUN apt-get update -qq \
    # Add the signing key r-project repos
    && wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc \
        | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc \
    && add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu jammy-cran40/" \
    && apt-get -y install r-base r-base-core r-recommended r-base-dev \
    && apt-get -y install \
        libcurl4-openssl-dev libssl-dev libboost-dev libxml2-dev \
        libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev \
    && apt-get clean && apt-get purge \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN git clone https://github.com/bvaldebenitom/SoloTE.git \
    && cd SoloTE \
    && find . -maxdepth 1 -not -name 'SoloTE_1.07' -exec rm -rfv '{}' \; \
    && cd SoloTE_1.07 \
    && sed -i '1 i #!/usr/bin/env python3' SoloTE_pipeline.py
WORKDIR /opt2 

################ POST #################
# Copy the Dockerfile used to create image in /opt2
COPY Dockerfile /opt2
RUN chmod a+x /opt2/SoloTE/SoloTE_1.07/* 
ENV PATH="/opt2/SoloTE/SoloTE_1.07:$PATH"
ENV PATH="/opt2/samtools-1.17:$PATH"
WORKDIR /data2