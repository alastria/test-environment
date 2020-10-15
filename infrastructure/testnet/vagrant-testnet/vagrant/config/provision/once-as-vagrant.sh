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

cd /var/www/vhosts/${domain}.test

info "Create bash-alias '${domain}' for vagrant user"
echo "alias ${domain}=\"cd /var/www/vhosts/${domain}.test\"" | tee /home/vagrant/.bash_aliases

info "Enabling colorized prompt for guest console"
sed -i "s/#force_color_prompt=yes/force_color_prompt=yes/" /home/vagrant/.bashrc

info "Link to shared folder from home path"
ln -s /vagrant /home/vagrant/shared
