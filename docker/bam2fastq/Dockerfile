FROM arvados/jobs
MAINTAINER Bryan Cosca <bcosca@curii.com>

USER root

RUN apt-get update -qy
RUN apt-get install -qy build-essential wget cmake zlib1g-dev python-pip unzip libbz2-dev liblzma-dev libcurl4-openssl-dev libncurses-dev git

RUN git clone --recursive https://github.com/jts/bam2fastq
WORKDIR /bam2fastq
RUN make

WORKDIR /

