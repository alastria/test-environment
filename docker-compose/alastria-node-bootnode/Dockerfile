FROM ubuntu:20.04

ARG NODE_VERSION
ARG NODE_KEY
ARG NODE_TYPE

ENV TZ=Europe/Madrid
ENV PRIVATE_CONFIG="ignore"

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update 
RUN apt-get -y install \
        wget \
        nano \
        vim \ 
        cron \      
    && apt-get autoremove \
    && apt-get clean

RUN apt-get install -y golang

WORKDIR /root
RUN wget -O geth_${NODE_VERSION}_linux_amd64.tar.gz https://artifacts.consensys.net/public/go-quorum/raw/versions/${NODE_VERSION}/geth_${NODE_VERSION}_linux_amd64.tar.gz
RUN tar zxvf geth_${NODE_VERSION}_linux_amd64.tar.gz -C /usr/local/bin

COPY genesis.json /root/genesis.json

COPY ${NODE_KEY} /root/alastria/data/geth/nodekey
COPY nodes-${NODE_TYPE}.json /root/alastria/data/static-nodes.json
COPY nodes-${NODE_TYPE}.json /root/alastria/data/permissioned-nodes.json

RUN /usr/local/bin/geth --datadir /root/alastria/data init /root/genesis.json

COPY geth.common.sh /root/geth.common.sh
COPY geth.node.${NODE_TYPE}.sh /root/geth.node.${NODE_TYPE}.sh

COPY entrypoint.sh /usr/local/bin/

RUN ["chmod", "+x", "/usr/local/bin/entrypoint.sh"]

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
