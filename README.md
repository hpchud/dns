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

The data that is used to populate the dns server must be in another repository and passed to the container through environment variable `CONFIG_REPO`.

On startup, this repository will be cloned using `CONFIG_USER` and `CONFIG_PASS` as the credentials. Whilst this image can be public, you don't want the configuration to be.

Look at the `hpchud/dns-config-template` repository as an example.
