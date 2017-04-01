FROM resin/rpi-raspbian:jessie

LABEL maintainer "T Koopman"

RUN apt-get update && \
    apt-get install -y \
        iptables \
        dnsmasq \
        fail2ban \
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