FROM arvados/jobs:latest
USER root
MAINTAINER Sarah Wait Zaranek <swz@curii.com>

RUN apt-get update -qy
RUN apt-get install -qy build-essential wget cmake zlib1g-dev python-pip unzip libbz2-dev liblzma-dev libcurl4-openssl-dev libncurses-dev

RUN mkdir -p /usr/share/man/man1
RUN apt-get install -qy default-jdk

ADD fastqc_v0.11.9.zip /
RUN unzip fastqc_v0.11.9.zip

WORKDIR /

