#!/bin/bash

function cinfo() {
	COLOR='\033[01;33m'	# bold yellow
	RESET='\033[00;00m'	# normal white
	MESSAGE=${@:-"${RESET}Error: No message passed"}
	echo -e "${COLOR}${MESSAGE}${RESET}"
}

CHEF_SERVER_IP=123.456.789.0
CHEF_SERVER_PASS=Password
CHEF_SERVER_USER=User
CHEF_USERNAME=Username

set -x

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

SUDO_USER=root
HOMEDIR=$(getent passwd ${SUDO_USER} | cut -d: -f6)

sudo apt-get install -y --force-yes sshpass

cinfo "Copying Chef key from Chef Server to workstation"
mkdir ~/.chef
cat /dev/null > ~/.ssh/known_hosts
sshpass -p "$CHEF_SERVER_PASS" scp -o StrictHostKeyChecking=no $CHEF_SERVER_USER@$CHEF_SERVER_IP:/tmp/$CHEF_USERNAME.pem ~/.chef/$CHEF_USERNAME.pem 

cinfo "Installing Dependancies"
sudo apt-get update -y --force-yes
sudo apt-get upgrade -y --force-yes
sudo apt-get install -y --force-yes ruby ruby-dev libopenssl-ruby rdoc ri irb build-essential wget ssl-cert curl

cinfo "Installing RubyGems"
cd /tmp
curl -O http://production.cf.rubygems.org/rubygems/rubygems-1.8.10.tgz
tar zxf rubygems-1.8.10.tgz
cd rubygems-1.8.10
sudo ruby setup.rb --no-format-executable

cinfo "Installing Chef"
sudo gem install chef --no-ri --no-rdoc

cinfo "Configuring Chef"
knife configure

cinfo "Installing rackspace plugin"
cd ..
sudo apt-get install -y --force-yes libxslt-dev libxml2-dev
gem install knife-rackspace

read -p "Enter your Rackspace username:" username
read -p "Enter your Rackspace API key:" api_key
read -p "Enter your Rackspace version:" version
read -p "Enter your Rackspace authentication url:" auth_url
read -p "Enter the Rackspace region endpoint:" endpoint

cat >> ${HOMEDIR}/.chef/knife.rb <<EOF
knife[:rackspace_api_username] = "$username"
knife[:rackspace_api_key] = "$api_key"
knife[:rackspace_version] = "$version"
knife[:rackspace_api_auth_url] = "$auth_url"
knife[:rackspace_endpoint] = "$endpoint"
EOF	


