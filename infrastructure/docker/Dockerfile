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
EXPOSE 3000

COPY ./scripts/start.sh /opt/test-environment/infrastructure/testnet
RUN chmod +x /opt/test-environment/infrastructure/testnet/start.sh

WORKDIR /opt/test-environment/infrastructure/testnet
