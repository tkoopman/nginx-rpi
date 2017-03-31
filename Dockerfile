FROM resin/rpi-raspbian:jessie

LABEL maintainer "T Koopman"

RUN apt-get update && \
    apt-get install -y \
        iptables \
        dnsmasq \
        fail2ban \
        nginx

copy start.sh /sbin/start.sh
        
# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    echo "\n\nuser=root\naddn-hosts=/etc/hosts\n" >> /etc/dnsmasq.conf && \
    chmod +x /sbin/start.sh


VOLUME ["/www"]
VOLUME ["/config"]

EXPOSE 80 443

CMD /sbin/start.sh

# Clean up APT when done. 
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*