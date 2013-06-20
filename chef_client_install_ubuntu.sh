#!/bin/bash

function cinfo() {
	COLOR='\033[01;33m'	# bold yellow
	RESET='\033[00;00m'	# normal white
	MESSAGE=${@:-"${RESET}Error: No message passed"}
	echo -e "${COLOR}${MESSAGE}${RESET}"
}

CHEF_CLIENT_IP="123.456.798.0"
CHEF_CLIENT_PASS="Password"
CHEF_CLIENT_USER="User"

cinfo "Installing Dependancies"
sudo apt-get install -y --force-yes sshpass

cinfo "Connecting to Chef Client Server and installing chef client"
cat >> ~/.ssh/known_hosts<<EOF
EOF
sshpass -p $CHEF_CLIENT_PASS ssh -t -t $CHEF_CLIENT_USER@$CHEF_CLIENT_IP ' 
cat >> hello.txt<<EOF
asfklajsdflj
EOF

sudo apt-get update -y --force-yes
sudo apt-get install -y --force-yes ruby ruby-dev libopenssl-ruby rdoc ri irb build-essential wget ssl-cert curl

cd /tmp
curl -O http://production.cf.rubygems.org/rubygems/rubygems-1.8.10.tgz
tar zxf rubygems-1.8.10.tgz
cd rubygems-1.8.10
sudo ruby setup.rb --no-format-executable

sudo gem install chef --no-ri --no-rdoc

sudo mkdir -p /etc/chef

exit'


cinfo "Creating config files"
knife configure client ./

cinfo "Copying config files to client server"
sshpass -p $CHEF_CLIENT_PASS scp client.rb $CHEF_CLIENT_USER@$CHEF_CLIENT_IP:/etc/chef/client.rb
sshpass -p $CHEF_CLIENT_PASS scp validation.pem $CHEF_CLIENT_USER@$CHEF_CLIENT_IP:/etc/chef/validation.pem



