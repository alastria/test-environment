#!/usr/bin/env bash

#== Import script args ==

#github_token=$(echo "$1")
domain=$(echo "$1")
migrations=$(echo "$2")

#== Bash helpers ==

function info {
  echo " "
  echo "--> $1"
  echo " "
}

#== Provision script ==

info "Provision-script user: `whoami`"

# Github token disabled
#info "Configure composer"
#composer config --global github-oauth.github.com ${github_token}
#echo "Done!"

cd /var/www/vhosts/${domain}.test

#info "Init project"
# composer install
# php init --env=Development --overwrite=n

# Project config changes
# sed -i -E "s/('password'.+')(.+?)(')/\11234\3/" /var/www/vhosts/${domain}.test/common/config/main-local.php
# sed -i -E "s/(dbname=)(.+?)('.+)/\1${domain}\3/" /var/www/vhosts/${domain}.test/common/config/main-local.php
# sed -i -E "s/(dbname=)(.+?)('.+)/\1${domain}_test\3/" /var/www/vhosts/${domain}.test/common/config/test-local.php

# info "Apply migrations"
# if [ "${migrations}" = "y" ]
# then
#     php yii migrate --interactive=0
# 	php yii_test migrate --interactive=0
# else
#     echo "Yii migrations not applied. (Check the config file vagrant-local.yml to configure)"
# fi

info "Create bash-alias '${domain}' for vagrant user"
echo "alias ${domain}=\"cd /var/www/vhosts/${domain}.test\"" | tee /home/vagrant/.bash_aliases

info "Enabling colorized prompt for guest console"
sed -i "s/#force_color_prompt=yes/force_color_prompt=yes/" /home/vagrant/.bashrc

info "Link to shared folder from home path"
ln -s /vagrant /home/vagrant/shared
