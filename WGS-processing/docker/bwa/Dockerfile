FROM arvados/jobs:latest
USER root
MAINTAINER Sarah Wait Zaranek <swz@curii.com>

RUN apt-get update -qy
RUN apt-get install -qy build-essential wget cmake zlib1g-dev python-pip unzip libbz2-dev liblzma-dev libcurl4-openssl-dev libncurses-dev

RUN mkdir -p /usr/share/man/man1
RUN apt-get install -qy default-jdk

ADD bwa-0.7.17.tar.bz2 /
WORKDIR bwa-0.7.17
RUN make

ADD samtools-1.10.tar.bz2 /
WORKDIR /samtools-1.10
RUN ./configure && make && make install

ADD picard.jar /

WORKDIR /

