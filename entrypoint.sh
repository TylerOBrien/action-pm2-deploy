#!/bin/sh

set -eu

#
# Prepare SSH config
#

echo "$INPUT_KEY" > /etc/ssh/remote.key
echo "$INPUT_PROXY_KEY" > /etc/ssh/proxy.key

chmod 400 /etc/ssh/remote.key
chmod 400 /etc/ssh/proxy.key

echo "Host destination" >> /etc/ssh/ssh_config
echo " User $INPUT_USER" >> /etc/ssh/ssh_config
echo " HostName $INPUT_HOST" >> /etc/ssh/ssh_config
echo " StrictHostKeyChecking=no" >> /etc/ssh/ssh_config
echo " IdentityFile /etc/ssh/remote.key" >> /etc/ssh/ssh_config

if [ "$INPUT_PROXY_DISABLED" != "1" ]; then
    echo " ProxyJump proxy" >> /etc/ssh/ssh_config
    
    echo "Host proxy" >> /etc/ssh/ssh_config
    echo " User $INPUT_PROXY_USER" >> /etc/ssh/ssh_config
    echo " HostName $INPUT_PROXY_HOST" >> /etc/ssh/ssh_config
    echo " StrictHostKeyChecking=no" >> /etc/ssh/ssh_config
    echo " IdentityFile /etc/ssh/proxy.key" >> /etc/ssh/ssh_config
fi

#
# Main
#

ssh destination "cp -r ""$INPUT_SOURCE"" ""$INPUT_DESTINATION""; pm2 restart all"
