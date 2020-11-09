#!/usr/bin/env bash

#== Import script args ==

timezone=$(echo "$1")
commit=$(echo "$2")
ubuntu=$(echo "$3")
validator=$(echo "$4")
general=$(echo "$5")
faulty=$(echo "$6")

#== Bash helpers ==

function info {
  echo " "
  echo "--> $1"
  echo " "
}

#== Provision script ==

info "Provision-script user: `whoami`"
export DEBIAN_FRONTEND=noninteractive

info "Configuring timezone"
timedatectl set-timezone ${timezone} --no-ask-password

info "Configuring keyboard layout"
L='es' && sudo sed -i 's/XKBLAYOUT=\"\w*"/XKBLAYOUT=\"'$L'\"/g' /etc/default/keyboard

# info "Updating OS software..."
apt-get update
# apt-get upgrade -y
info "Installing software..."
    apt-get install -y curl dirmngr apt-transport-https lsb-release ca-certificates
    curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
apt-get install -y software-properties-common unzip wget git make gcc libsodium-dev build-essential libdb-dev zlib1g-dev libtinfo-dev libtinfo5 sysvbanner psmisc libleveldb-dev libdb5.3-dev dnsutils sudo netcat docker docker-compose nodejs openjdk-11-jdk mysql-server
apt-get install -y libjffi-jni #! TODO PROVISIONAL
npm install -g truffle@5.1.48
npm install -g keythereum@1.2.0
mavenver="3.6.3"
echo 'export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64' >> /etc/bash.bashrc
wget "https://ftp.cixug.es/apache/maven/maven-3/$mavenver/binaries/apache-maven-$mavenver-bin.zip" -O /opt/maven.zip --progress=bar:force
pushd /opt
unzip maven.zip && rm maven.zip
popd
PATH=/opt/apache-maven-$mavenver/bin:$PATH
echo "export PATH=/opt/apache-maven-$mavenver/bin:$PATH" >> /home/vagrant/.bashrc
echo "export PATH=/opt/apache-maven-$mavenver/bin:$PATH" >> /home/vagrant/.profile

# wget https://downloads.mysql.com/archives/get/p/3/file/mysql-connector-java_8.0.21-1ubuntu20.04_all.deb -O mysql-connector.deb
# dpkg -i mysql-connector.deb

cd /home/vagrant
wget https://downloads.mysql.com/archives/get/p/3/file/mysql-connector-java-8.0.21.zip -O mysql.zip
unzip mysql.zip && rm mysql.zip
cd mysql-connector-java-8.0.21
mv mysql-connector-java-8.0.21.jar ../mysql.jar

info "Configure MySQL"
# For fix "this is incompatible with sql_mode=only_full_group_by"
echo $'[mysqld]\nsql_mode = "STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION"' >> /etc/mysql/my.cnf
sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
# Create DBs
mysql -uroot <<< "CREATE DATABASE IF NOT EXISTS testnetdb DEFAULT CHARACTER SET utf8;"
mysql -uroot <<< "CREATE DATABASE IF NOT EXISTS testnetdb_test DEFAULT CHARACTER SET utf8;"
# DB users and permissions
mysql -uroot <<< "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '1234'"
mysql -uroot -p1234 <<< "CREATE USER 'root'@'*' IDENTIFIED BY '1234'"
mysql -uroot -p1234 <<< "GRANT ALL PRIVILEGES ON *.* TO 'root'@'*'"
mysql -uroot -p1234 <<< "CREATE USER 'tessera'@'localhost' IDENTIFIED BY '1234'"
mysql -uroot -p1234 <<< "GRANT ALL PRIVILEGES ON *.* TO 'tessera'@'localhost'"
mysql -uroot -p1234 <<< "FLUSH PRIVILEGES"
echo "Done!"
info "Restart mysqld to get new config"
service mysql restart

info "Cloning and initializing testnet related repositories..."
# cd /home/vagrant
# git clone https://github.com/alastria/test-environment.git
# cd test-environment
# git checkout ${commit}
# cp -R /home/vagrant/test-environment/infrastructure/testnet/network / #TODO: probando que esto no es necesario ya que el clean la crea cada vez...
cd /home/vagrant/test-environment/infrastructure/testnet
bash bin/bootstrap.sh
cd /home/vagrant
git clone https://github.com/Councilbox/cbx-quorum-explorer.git
cd cbx-quorum-explorer
mkdir mongo_data_dir
bash -c "curl https://raw.githubusercontent.com/alastria/test-environment/feature/tidyup-testnet/infrastructure/common/docker-compose.yaml.template > docker-compose.yaml.template"
read -r -d '' env << EOF
QUORUM_ENDPOINTS=localhost:22000,localhost:22001,localhost:22002,localhost:22003,localhost:22005
QUORUM_HOST=localhost
ENABLE_SSL=false
EXPLORER_PORT=8888
API_DOMAIN=localhost
MONGO_DATA_DIR=/home/vagrant/cbx-quorum-explorer/mongo_data_dir
API_PORT=
EXTERNAL_API_PORT=
WEBAPP_VERSION=alastria-telsius
EOF
echo "$env" > env.sh
bash build.sh
bash launch.sh

echo "Initializing testnet with ${validator} validator nodes, ${general} general nodes and ${faulty} nodes."
cd /home/vagrant/test-environment/infrastructure/testnet
bash bin/start_network.sh clean ${validator} ${general} --faulty-node ${faulty}
bash bin/stop_network.sh

info "Finished installing VM"
