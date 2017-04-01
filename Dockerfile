FROM resin/rpi-raspbian:jessie

LABEL maintainer "T Koopman"

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 7638D0442B90D010 && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8B48AD6246925553 && \
    echo 'deb http://httpredir.debian.org/debian jessie-backports main contrib non-free' > /etc/apt/sources.list.d/jessie-backports.list && \
    apt-get update && \
    apt-get install -y \
        iptables \
        dnsmasq \
        fail2ban  && \
    apt-get install -y -t jessie-backports \
        nginx

copy start.sh /sbin/start.sh

VOLUME ["/www"]
VOLUME ["/config"]
VOLUME ["/log"]

# forward request and error logs to docker log collector
RUN ln -sf /log/access.log /var/log/nginx/access.log && \
    ln -sf /log/error.log /var/log/nginx/error.log && \
    ln -sf /log/fail2ban.log /var/log/fail2ban.log && \
    echo "\n\nuser=root\naddn-hosts=/etc/hosts\n" >> /etc/dnsmasq.conf && \
    chmod +x /sbin/start.sh

EXPOSE 80 443

CMD /sbin/start.sh

# Clean up APT when done. 
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
