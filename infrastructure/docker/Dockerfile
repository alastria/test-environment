FROM alastria-base
LABEL maintainer="Carlos Morales  <cmoralesdiego@deloitte.es>"

# Monitoring
EXPOSE 8443/tcp
# Constellation port
EXPOSE 9000/tcp
# Communication between geth processes
EXPOSE 21000-21010/tcp
EXPOSE 21000-21010/udp
# RPC
EXPOSE 22000-22010/tcp
# ETHSTATS
EXPOSE 3000/tcp

COPY ./scripts/start.sh /opt/test-environment/infrastructure/testnet
RUN chmod +x /opt/test-environment/infrastructure/testnet/start.sh
RUN chmod +x /opt/test-environment/infrastructure/testnet/bin/start_ethstats.sh
#RUN bash /opt/test-environment/infrastructure/testnet/bin/start_ethstats.sh
#RUN git clone https://github.com/cubedro/eth-netstats
#RUN cd eth-netstats
#RUN npm install
#RUN npm install -g grunt-cli
#RUN grunt
#RUN nohup env WS_SECRET=bb98a0b6442386d0cdf8a31b267892c1 npm start >> "${EPWD}"/logs/netstat_"${_TIME}".log &
WORKDIR /opt/test-environment/infrastructure/testnet
