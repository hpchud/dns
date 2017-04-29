#!/bin/bash

set -e

DNSMASQ_DIR=/etc/dnsmasq.d

# check for required vars
if [[ -z "$CONFIG_REPO" ]]; then
    echo -n >&2 "Error: no configuration repository is set "
    echo >&2 "Did you forget to add -e CONFIG_REPO=... ?"
    exit 1
fi
if [[ -z "$CONFIG_USER" ]]; then
    echo -n >&2 "Error: the user or team name is not set "
    echo >&2 "Did you forget to add -e CONFIG_USER=... ?"
    exit 1
fi
if [[ -z "$CONFIG_PASS" ]]; then
    echo -n >&2 "Error: the password or API key is not set "
    echo >&2 "Did you forget to add -e CONFIG_PASS=... ?"
    exit 1
fi

# reset dnsmasq if it has already been configured
if [[ -f "/etc/hosts.dnsmasq" ]]; then 
    echo "dnsmasq already configured, wiping it"
    rm -rf /etc/dnsmasq.d/*
    rm -rf /etc/hosts.dnsmasq
    rm -rf /tmp/dns-config
fi

# clone the git repo
echo "cloning config repository..."
git clone https://${CONFIG_USER}:${CONFIG_PASS}@${CONFIG_REPO} /tmp/dns-config
cd /tmp/dns-config

if [ -f "./pre.sh" ]; then
    echo "running pre-setup script..."
    chmod a+x ./pre.sh
    ./pre.sh
fi

echo "adding hosts..."
cp ./config/hosts /etc/hosts.dnsmasq
echo "addn-hosts=/etc/hosts.dnsmasq" > /etc/dnsmasq.d/1hosts.conf

echo "adding conf files..."
cp -r ./config/dnsmasq.d/*.conf /etc/dnsmasq.d/

if [ -f "./post.sh" ]; then
    echo "running post-setup script..."
    chmod a+x ./post.sh
    ./post.sh
fi

echo "starting the server"
exec "$@"
