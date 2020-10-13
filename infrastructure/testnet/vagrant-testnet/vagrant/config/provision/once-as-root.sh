#!/usr/bin/env bash

#== Import script args ==

timezone=$(echo "$1")
domain=$(echo "$2")
frontendport=$(echo "$3")
backendport=$(echo "$4")

#== Bash helpers ==

function info {
  echo " "
  echo "--> $1"
  echo " "
}

#== Provision script ==

info "Provision-script user: `whoami`"
export DEBIAN_FRONTEND=noninteractive

info "If you want to install php and mysql cancel this procces (CTRL+C), uncomment provisioner lines from line 50 onwards in the once-as-root file and all lines in the always-as-root and once-as-vagrant files and try vagrant up again."

info "Configure timezone"
timedatectl set-timezone ${timezone} --no-ask-password

info "Configure keyboard layout"
L='es' && sudo sed -i 's/XKBLAYOUT=\"\w*"/XKBLAYOUT=\"'$L'\"/g' /etc/default/keyboard

info "Update OS software"
# add-apt-repository ppa:ethereum/ethereum
apt-get update
# apt-get upgrade -y

info "Install packages"
apt-get install -y npm software-properties-common unzip wget git make gcc libsodium-dev build-essential libdb-dev zlib1g-dev libtinfo-dev libtinfo5 sysvbanner psmisc libleveldb-dev libdb5.3-dev dnsutils sudo netcat nodejs docker docker-compose
npm install -g truffle@5.1.48

# cd /usr/local
# git clone https://github.com/ethereum/go-ethereum.git
# PATH="$PATH:/usr/local/go-ethereum"
# cd go-ethereum
# git checkout v1.9.5
# make geth
# if ( ! type "geth" > /dev/null 2>&1 ) then
#   echo "Making geth from repository failed. Trying to install via Snap. BEWARE: version may change. This could result in errors."
#   snap install geth #BEWARE: version may change
# fi
cd /home/vagrant
git clone https://github.com/alastria/test-environment.git
cd test-environment
git checkout c4f8f0683a3539af635b910b241d8bef87fe59e5
cd infrastructure/testnet
bash bin/bootstrap.sh
cd /home/vagrant
git clone https://github.com/Councilbox/cbx-quorum-explorer.git
cd cbx-quorum-explorer
mkdir mongo_data_dir
curl https://gist.githubusercontent.com/brunneis/f6ffc3898635f2ab5718f8ab0f5f6905/raw/83a39419fea1ac6acc53230d83320f337d9df3ad/docker-compose.yaml.template > docker-compose.yaml.template

read -r -d '' env << EOF
QUORUM_ENDPOINTS=localhost:22000,localhost:22001,localhost:22002,localhost:22003,localhost:22005
ENABLE_SSL=false
EXPLORER_PORT=8888
API_DOMAIN=localhost
MONGO_DATA_DIR=/home/vagrant/projects/cbx-quorum-explorer/mongo_data_dir
API_PORT=
EXTERNAL_API_PORT=
WEBAPP_VERSION=cbx-alastria-telsius
EOF
echo "$env" > env.sh

bash build.sh
bash launch.sh

info "Install Desktop FOR DEVELOPMENT PURPOSES"
apt-get install -y --no-install-recommends ubuntu-desktop
# info "Install fundamental software"
# apt-get install -y npm solc mocha chai unzip
# info "Install Visual Studio Code"
# snap install --classic code
# info "Install OpenZeppelin"
# snap install openzeppelin --edge
# npm install -g @openzeppelin/cli
# npm install -g @openzeppelin/contracts
# info "Install Truffle"
# npm install -g truffle --unsafe-perm
# info "Install Ganache"
# npm install -g ganache-cli --unsafe-perm
# info "Install web3"
# npm install -g web3
info "Install utilitary software FOR DEVELOPMENT PURPOSES"
apt-get install -y firefox evince nautilus-extension-gnome-terminal
# npm install -g nyc

# info "Prepare root password for MySQL"
# debconf-set-selections <<< "mysql-community-server mysql-community-server/root-pass password \"'1234'\""
# debconf-set-selections <<< "mysql-community-server mysql-community-server/re-root-pass password \"'1234'\""
# echo "Done!"

# info "Update OS software"
# add-apt-repository ppa:ondrej/php
# apt-get update
# apt-get upgrade -y

# info "Install PHP and MySQL"
# apt-get install -y php7.2-curl php7.2-cli php7.2-intl php7.2-mysqlnd php7.2-gd php7.2-fpm php7.2-mbstring php7.2-xml php7.2-zip php7.2-soap nginx mysql-server-8 pwgen

# info "Configure MySQL"
# # For fix "this is incompatible with sql_mode=only_full_group_by" (idea_hogar)
# echo $'[mysqld]\nsql_mode = "STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION"' >> /etc/mysql/my.cnf
# sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
# # Create DBs
# mysql -uroot <<< "CREATE DATABASE IF NOT EXISTS ${domain} DEFAULT CHARACTER SET utf8;"
# mysql -uroot <<< "CREATE DATABASE IF NOT EXISTS ${domain}_test DEFAULT CHARACTER SET utf8;"
# # DB users and permissions
# mysql -uroot <<< "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '123'"
# mysql -uroot -p123 <<< "CREATE USER 'root'@'10.0.2.2' IDENTIFIED BY '123'"
# mysql -uroot -p123 <<< "GRANT ALL PRIVILEGES ON *.* TO 'root'@'10.0.2.2'"
# #mysql -uroot -p123 <<< "CREATE USER '${domain}'@'localhost' IDENTIFIED BY '$pw_db';"
# #mysql -uroot -p123 <<< "CREATE USER '${domain}'@'10.0.2.2' IDENTIFIED BY '$pw_db';"
# #mysql -uroot -p123 <<< "GRANT ALL PRIVILEGES ON ${domain}.* TO '${domain}'@'localhost';"
# #mysql -uroot -p123 <<< "GRANT ALL PRIVILEGES ON ${domain}.* TO '${domain}'@'10.0.2.2';"
# #mysql -uroot -p123 <<< "DROP USER 'root'@'localhost'"
# mysql -uroot -p123 <<< "FLUSH PRIVILEGES"
# echo "Done!"

# info "Restart mysqld to get new config"
# service mysql restart

# info "Enabling site configuration"
# cp -n /vagrant/vagrant/config/nginx/app-example.conf /vagrant/vagrant/config/nginx/app.conf
# ln -s /vagrant/vagrant/config/nginx/app.conf /etc/nginx/sites-enabled/${domain}.test
# sed -i --follow-symlinks "s/yiiapp/${domain}/" /etc/nginx/sites-enabled/${domain}.test
# sed -i --follow-symlinks "0,/listen 80/s//listen ${frontendport}/" /etc/nginx/sites-enabled/${domain}.test
# sed -i --follow-symlinks "0,/listen 80/s//listen ${backendport}/" /etc/nginx/sites-enabled/${domain}.test
# echo "Done!"

# #info "Change ports"
# #sed -i -E "s/(post_max_size = )(.+)/\1128M/" /etc/nginx/7.2/fpm/php.ini
# #sed -i -E "s/(upload_max_filesize = )(.+)/\1128M/" /etc/php/7.2/fpm/php.ini
# #echo "Done!"

# #info "Configure PHP FPM"
# #ln -s /vagrant/config/nginx/app.conf /etc/nginx/sites-enabled/${domain}.test
# #sed -i -E "s/(post_max_size = )(.+)/\1128M/" /etc/php/7.2/fpm/php.ini
# #sed -i -E "s/(upload_max_filesize = )(.+)/\1128M/" /etc/php/7.2/fpm/php.ini
# #echo "Done!"

# info "Install composer"
# curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# TODO:
# info "Creating developer user"
# useradd -m -s /bin/bash -U developer

info "Finished installing VM"
