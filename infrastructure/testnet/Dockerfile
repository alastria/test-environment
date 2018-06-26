FROM ubuntu:16.04

LABEL maintainer "Alfonso de la Rocha (https://github.com/arochaga)"

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    make \
    wget \
    sudo \
    netcat\
    nodejs \
    npm \
    software-properties-common \
    unzip \
    gcc \
    libsodium-dev \
    build-essential \
    libdb-dev \
    zlib1g-dev \
    libtinfo-dev \
    sysvbanner \
    psmisc \
    libleveldb-dev
RUN ln -s /usr/bin/nodejs /usr/bin/node
# Copy installation script
COPY . /opt

# Change working directory
WORKDIR /opt

# Install all dependencies
RUN ./bin/bootstrap.sh
# Start ethstats
RUN ./bin/start_ethstats.sh
# Build geth for faulty_nodes
RUN ./bin/build_faulty_nodes.sh

# Monitoring
EXPOSE 8443/tcp
# Netstats port
EXPOSE 3000/tcp
# Constellation ports
EXPOSE 9000-9110/tcp
# Communication between geth processes
EXPOSE 21000-21110/tcp
EXPOSE 21000-21110/udp
# RPC
EXPOSE 22000-22010/tcp

# COPY ./scripts/start.sh /opt/test-environment/infrastructure/testnet
# RUN chmod +x /opt/test-environment/infrastructure/testnet/start.sh

# WORKDIR /opt/test-environment/infrastructure/testnet
CMD ["bash"]
