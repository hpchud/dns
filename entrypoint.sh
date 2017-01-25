#!/bin/bash

# originally based on https://github.com/dinkel/docker-openldap

# When not limiting the open file descritors limit, the memory consumption of
# slapd is absurdly high. See https://github.com/docker/docker/issues/8231
ulimit -n 8192

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
fi

# clone the git repo
echo "cloning config repository..."
git clone https://${CONFIG_USER}:${CONFIG_PASS}@${CONFIG_REPO} /root/dns-config

echo "adding hosts..."
cp /root/dns-config/hosts /etc/hosts.dnsmasq
echo "addn-hosts=/etc/hosts.dnsmasq" > /etc/dnsmasq.d/1hosts.conf

echo "adding conf files..."
cp -r /root/dns-config/dnsmasq.d/*.conf /etc/dnsmasq.d/

if [ -f "/root/dns-config/post.sh" ]; then
    echo "running post-setup script..."
    chmod a+x /root/dns-config/post.sh
    /root/dns-config/post.sh
fi

echo "starting the server"
exec "$@"