# nginx-rpi
Docker image of nginx with fail2ban &amp; dnsmasq for Raspberry Pi

- [Introduction](#introduction)
- [How to Run](#howtorun)
- [Configuration](#config)
- [Tags](#tags)
- [Links](#links)

# Introduction
Docker image for nginx web server / reverse proxy. Contains fail2ban to help deter brute force attachs, and dnsmasq to help with connecting to other docker web server containers.

# How to Run
```shell
docker run \
    --name nginx \
    -p 80:80 \
    -p 443:443 \
    -v /path/to/config/dir:/config \
    -v /path/to/www/dir:/www \
    -v /path/to/log/dir:/log \
    --env "TIMEZONE=$(cat /etc/timezone)" \
    --cap-add=NET_ADMIN \
    --restart=always \
    --detach \
    tkoopman/nginx-rpi
```

# Configuration
Config directory is broken into two subdirectories.
* /config/nginx
* /config/fail2ban

If directories are missing they will be created and populated with default configurations for this build.

# Tags
Currently have two active tags.
## tkoopman/nginx-rpi:latest
This is running the standard version of nginx for jessie
## tkoopman/nginx-rpi:backport
This is running the newer version of nginx from jessie-backports

# Links
Docker Hub: https://hub.docker.com/r/tkoopman/nginx-rpi/

Source: https://github.com/tkoopman/nginx-rpi
