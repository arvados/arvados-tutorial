FROM arvados/jobs:latest
USER root
MAINTAINER Sarah Wait Zaranek <swz@curii.com>

# Install python tools
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -qy apt-utils unzip autoconf wget python-pip python-numpy python-scipy python-matplotlib python-pandas 

RUN apt-get upgrade -y
RUN apt-get clean

# Install lib files to build SAMtools
RUN apt-get install -qy libncurses5-dev libbz2-dev liblzma-dev git autoconf zlib1g-dev zlib1g xz-utils liblzma-dev libpthread-stubs0-dev 
RUN apt-get install -qy libcurl3-openssl-dev libssl-dev bc build-essential parallel cmake 

# Install SDSL
RUN cd /tmp && git clone 'https://github.com/simongog/sdsl-lite.git' && cd sdsl-lite && ./install.sh /usr/local
RUN apt-get remove libhts-dev

# Install htslib 1.10.2
RUN cd /tmp && wget http://github.com/samtools/htslib/archive/1.10.2.zip && unzip 1.10.2 && cd htslib-1.10.2 && make && make install && cd /tmp && rm -rf htslib-1.10.2 && ldconfig

# Install bcftools 1.10.2
RUN wget http://github.com/samtools/bcftools/archive/1.10.2.zip && unzip 1.10.2 && cd bcftools-1.10.2 && autoheader && autoconf && ./configure && make && make install

CMD /bin/sh
