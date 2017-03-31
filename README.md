# nginx-rpi
Docker image of nginx with fail2ban &amp; dnsmasq for Raspberry Pi

- [Introduction](#introduction)
- [How to Run](#howtorun)
- [Configuration](#config)

# Introduction
Docker image for nginx web server / reverse proxy. Contains fail2ban to help deter brute force attachs, and dnsmasq to help with connecting to other docker web server containers.

# How to Run
```shell
docker create \
    --name nginx \
    -p 80:80 \
    -p 443:443 \
    -v /path/to/config/dir:/config:ro \
    -v /path/to/www/dir:/www:ro \
    --cap-add=NET_ADMIN \
    tkoopman/nginx-rpi
```

# Configuration
Config directory is broken into two subdirectories.
* /config/nginx
* /config/fail2ban

If directories are missing they will be created and populated with default configurations for this build.
