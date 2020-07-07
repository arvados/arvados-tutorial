FROM arvados/jobs:latest
USER root
MAINTAINER Sarah Wait Zaranek <swz@curii.com>

RUN apt-get update -qy
RUN apt-get install -qy build-essential wget cmake zlib1g-dev python-pip unzip libbz2-dev liblzma-dev libcurl4-openssl-dev libncurses-dev autoconf git

RUN mkdir -p /usr/share/man/man1
RUN apt-get install -qy default-jdk

# Install SDSL
RUN cd /tmp && git clone 'https://github.com/simongog/sdsl-lite.git' && cd sdsl-lite && ./install.sh /usr/local
RUN apt-get remove libhts-dev

# Install htslib 1.10.2
RUN cd /tmp && wget http://github.com/samtools/htslib/archive/1.10.2.zip && unzip 1.10.2 && cd htslib-1.10.2 && make && make install && cd /tmp && rm -rf htslib-1.10.2 && ldconfig

# Install samtools 1.10
RUN wget https://github.com/samtools/samtools/archive/1.10.zip && unzip 1.10 && cd samtools-1.10 && autoheader && autoconf && ./configure && make && make install

# Install BWA 07.7.17
RUN wget https://github.com/lh3/bwa/archive/v0.7.17.zip && unzip v0.7.17 && cd bwa-0.7.17 && make 

CMD /bin/sh
