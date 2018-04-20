FROM ubuntu
RUN apt-get update && apt-get install -y git wget sudo curl

ARG NODE_TYPE

RUN echo $NODE_TYPE
RUN mkdir /root/alastria
#Persistance in /root/alastria/data
WORKDIR /root/
COPY . /root/

# ENV NETWORKID="1907"
# ENV ETH_USR_PASSWD=""
# ENV DATADIR="main_private_network"
# ENV RPCPORT="8080"
# ENV RPCADDR="0.0.0.0"
# ENV RPCCORSDOMAIN="*"
# ENV RPCAPI="admin,db,eth,debug,miner,net,shh,txpool,personal,web3"
# ENV PORT="30303"
# ENV IPCPATH="/opt/ethereum/geth.ipc"
# ENV GENESIS_ADDRESS="none"
# ENV MINE="0"
# ENV MINERTHREADS="1"
# ENV JSSCRIPT="none"


