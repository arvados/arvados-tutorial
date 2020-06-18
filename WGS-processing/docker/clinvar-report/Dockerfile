FROM arvados/jobs:latest
USER root
MAINTAINER Sarah Wait Zaranek <swz@curii.com>

# Install python tools
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y apt-utils && apt-get install -y unzip
RUN apt-get install autoconf -y 
RUN apt-get install wget -y 
RUN apt-get install python-pip -y
RUN apt-get install python-numpy -y && apt-get install python-scipy -y
RUN apt-get install python-matplotlib -y && apt-get install python-pandas -y
RUN apt-get upgrade -y
RUN apt-get clean

# install lib files to build SAMtools
RUN apt-get install libncurses5-dev -y && apt-get install libbz2-dev -y && apt-get install liblzma-dev -y && apt-get install git -y && apt-get install autoconf -y

# installing zlib1g
RUN apt-get install zlib1g-dev -y
RUN apt-get install zlib1g -y

# Installing xz-utils

RUN apt-get install xz-utils -y

# Installing liblzma-dev
RUN apt-get install liblzma-dev -y

# Installing pthreads
RUN apt-get install libpthread-stubs0-dev -y

# Installing libcurl
RUN apt-get install libcurl3-openssl-dev -y

# Installing libcrypto
RUN apt-get install libssl-dev -y

# Installing bc
RUN apt-get install bc -y

# installing build essentials
RUN apt-get install build-essential -y

# Installing parallel
RUN apt-get install parallel -y

# Installing Cmake
RUN apt-get install cmake -y

# Installing SDSL
RUN cd /tmp && git clone 'https://github.com/simongog/sdsl-lite.git' && cd sdsl-lite && ./install.sh /usr/local

RUN apt-get remove libhts-dev

# Installing htslib
RUN cd /tmp && wget http://github.com/samtools/htslib/archive/1.10.2.zip && unzip 1.10.2 && cd htslib-1.10.2 && make && make install && cd /tmp && rm -rf htslib-1.10.2 && ldconfig

# Installing bcftools

RUN wget http://github.com/samtools/bcftools/archive/1.10.2.zip && unzip 1.10.2 && cd bcftools-1.10.2 && autoheader && autoconf && ./configure && make && make install
