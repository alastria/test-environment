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
    libleveldb-dev \
    openjdk-11-jdk \ 
    mysql-server
RUN curl -sL https://deb.nodesource.com/setup_12.x -o nodesource_setup.sh
RUN sudo bash nodesource_setup.sh
RUN sudo cp /usr/lib/x86_64-linux-gnu/libsodium.so.23.1.0 /usr/lib/x86_64-linux-gnu/libsodium.so.18
RUN sudo npm install npm -g
RUN sudo npm install -g truffle@5.1.48
RUN npm install -g keythereum@1.2.0
RUN echo 'export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64' >> /etc/bash.bashrc
RUN cd /opt
RUN wget "https://ftp.cixug.es/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.zip" -O /opt/maven.zip --progress=bar:force
RUN whoami
RUN cd /opt
RUN unzip /opt/maven.zip && rm /opt/maven.zip
#RUN popd
RUN PATH=/opt/apache-maven-3.6.3/bin:$PATH
RUN echo "export PATH=/opt/apache-maven-3.6.3/bin:$PATH" >> /root/.bashrc
RUN echo "export PATH=/opt/apache-maven-3.6.3/bin:$PATH" >> /root/.profile

# wget https://downloads.mysql.com/archives/get/p/3/file/mysql-connector-java_8.0.21-1ubuntu20.04_all.deb -O mysql-connector.deb
# dpkg -i mysql-connector.deb

RUN cd /root
RUN wget https://downloads.mysql.com/archives/get/p/3/file/mysql-connector-java-8.0.21.zip -O /root/mysql.zip
RUN unzip /root/mysql.zip && rm /root/mysql.zip
RUN ls -lisa .
RUN cd  mysql-connector-java-8.0.21
RUN mv /mysql-connector-java-8.0.21/mysql-connector-java-8.0.21.jar ../mysql.jar
CMD service mysql start
RUN sleep 30
#RUN info "Configure MySQL"
# For fix "this is incompatible with sql_mode=only_full_group_by"
#RUN echo $'[mysqld]\nsql_mode = "STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION"' >> /etc/mysql/my.cnf
#RUN sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
# Create DBs
CMD mysql -uroot -e "CREATE DATABASE IF NOT EXISTS testnetdb DEFAULT CHARACTER SET utf8;"
CMD mysql -uroot -e "CREATE DATABASE IF NOT EXISTS testnetdb_test DEFAULT CHARACTER SET utf8;"
# DB users and permissions
CMD mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '1234'"
CMD mysql -uroot -p1234 -e "CREATE USER 'root'@'*' IDENTIFIED BY '1234'"
CMD mysql -uroot -p1234 -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'10.0.2.2'"
CMD mysql -uroot -p1234 -e "CREATE USER 'tessera'@'localhost' IDENTIFIED BY '1234'"
CMD mysql -uroot -p1234 -e "GRANT ALL PRIVILEGES ON *.* TO 'tessera'@'localhost'"
CMD mysql -uroot -p1234 -e "FLUSH PRIVILEGES"
RUN echo "Done!"
#RUN info "Restart mysqld to get new config"
#RUN sudo service mysql status
#RUN /sbin/start mysql &
#RUN /etc/init.d/mysql start
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
