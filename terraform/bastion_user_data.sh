#!/bin/bash

#### Update OS ####
sudo yum -y update

#### Timezone Config ####
sudo timedatectl set-timezone Asia/Bangkok

cd /home/ec2-user/
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.15.10/2020-02-22/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin