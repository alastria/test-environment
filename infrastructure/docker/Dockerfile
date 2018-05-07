FROM alastria-base
LABEL maintainer="Javi <nhitbh@gmail.com>"

# Monitoring
EXPOSE 8443/tcp
# Constellation port
EXPOSE 9000/tcp
# Communication between geth processes
EXPOSE 21000-21010/tcp
EXPOSE 21000-21010/udp
# RPC
EXPOSE 22000-22010/tcp

COPY ./scripts/start.sh /opt/test-environment/infrastructure/testnet
WORKDIR /opt/test-environment/infrastructure/testnet
