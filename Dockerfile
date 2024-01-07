FROM debian:stretch
LABEL maintainer="Vincent Lauria"

RUN apt-get update && apt-get install --no-install-recommends -y \
  git \
  make \
  gawk \
  ca-certificates \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install bats
RUN git clone https://github.com/sstephenson/bats.git \
  && cd bats \
  && ./install.sh /usr/local

# Install shdoc
RUN git clone --recursive https://github.com/reconquest/shdoc \
  && cd shdoc \
  && make install

WORKDIR /root/sheleton
