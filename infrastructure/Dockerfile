FROM ubuntu:16.04

LABEL maintainer "Alfonso de la Rocha (https://github.com/arochaga)"

ARG hostip
ARG nodetype
ARG nodename
ENV HOST_IP $hostip
ENV NODE_NAME $nodename

RUN \
  apt-get update && \
  apt-get install -y curl \
  libcurl3 unzip wget git make gcc libsodium-dev build-essential libdb-dev zlib1g-dev libtinfo-dev sysvbanner wrk psmisc sudo

RUN cd /root/ && git clone https://github.com/alastria/alastria-node.git
WORKDIR /root/alastria-node/scripts
RUN cd /root/alastria-node && git checkout feature/ibft

# COPY data /root/alastria-node/data
# RUN chmod -R u+x /root/alastria-node/data

# COPY scripts /root/alastria-node/scripts
# RUN chmod -R u+x /root/alastria-node/scripts

RUN sudo -H ./bootstrap.sh
RUN ./init.sh dockerfile $nodetype $nodename
# RUN ./start.sh

EXPOSE 9000 21000 21000/udp 22000 41000

# RUN ./start.sh
CMD ["./start.sh dockerfile"]
