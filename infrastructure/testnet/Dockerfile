FROM ubuntu:18.04

LABEL maintainer "Carlos Morales Diego (https://github.com/cmoralesdiego)"

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    make \
    wget \
    sudo \
    netcat\
    software-properties-common \
    unzip \
    gcc \
    libsodium-dev \
    build-essential \
    npm \
    libdb-dev \
    zlib1g-dev \
    libtinfo-dev \
    sysvbanner \
    psmisc \
    libleveldb-dev
RUN curl -sL https://deb.nodesource.com/setup_10.x -o nodesource_setup.sh
RUN sudo bash nodesource_setup.sh
RUN sudo cp /usr/lib/x86_64-linux-gnu/libsodium.so.23.1.0 /usr/lib/x86_64-linux-gnu/libsodium.so.18
RUN npm install -g truffle@5.1.48
RUN npm install -g keythereum@1.2.0
# RUN ln -s /usr/bin/nodejs /usr/bin/node
# Copy installation script
COPY . /opt

# Change working directory
WORKDIR /opt

# Install all dependencies
RUN ./bin/bootstrap-alastria-node.sh
# Start ethstats
RUN ./bin/start_ethstats.sh
# Build geth for faulty_nodes
# RUN ./bin/build_faulty_nodes.sh

# Monitoring
EXPOSE 8443/tcp
# Netstats port
EXPOSE 3000/tcp
# Constellation ports
EXPOSE 9000-9010/tcp
# Communication between geth processes
EXPOSE 21000-21010/tcp
EXPOSE 21000-21010/udp
# RPC
EXPOSE 22000-22010/tcp

# COPY ./scripts/start.sh /opt/test-environment/infrastructure/testnet
# RUN chmod +x /opt/test-environment/infrastructure/testnet/start.sh

# WORKDIR /opt/test-environment/infrastructure/testnet
CMD ["bash"]
