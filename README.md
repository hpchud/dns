# dns

This is the dns server.

# Running it

```
docker run -d -p 53:53 \
    -e CONFIG_REPO=bitbucket.org/hpchud/dns-config.git \
    -e CONFIG_USER=hpchud
    -e CONFIG_PASS=<api key> \
    hpchud/dns
```

# Configuring

The data that is used to populate the dns server must be in another repository and passed to the container through environment variable `CONFIG_REPO`. This repo must have the following layout:

```
./dnsmasq.d/
           <dnsmasq config files>
./hosts
./post.sh
```

On startup, this repository will be cloned using `CONFIG_USER` and `CONFIG_PASS` as the credentials. Whilst this image can be public, you don't want the configuration to be.

The files in `dnsmasq.d` folder will be added to the configuration of the DNS server.

The `hosts` file is in the same format as `/etc/hosts` and is used to populate the entries in the DNS server.

The `post.sh` script will be run once the above has been completed, before the server is started. This can be useful for setting up tftpboot assets that would otherwise be too large to store in a git repository.