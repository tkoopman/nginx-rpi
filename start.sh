#!/bin/bash
set -e

nginxConfDir=/config/nginx
nginxConf=$nginxConfDir/nginx.conf
fail2banConfDir=/config/fail2ban

if [ ! -d $nginxConfDir ]; then
    # Config file missing
    mkdir $nginxConfDir
    cp -rn /etc/nginx/* $nginxConfDir
    sed -i -e "s#/etc/nginx/#$nginxConfDir/#g" $nginxConf
    sed -i -e "s#/var/www/#/www/#g" $nginxConfDir/sites-available/default
    rm -f $nginxConfDir/sites-enabled/*
    ln -s ../sites-available/default $nginxConfDir/sites-enabled/default
    
    # Create html folder if missing
    # Only doing if conf was also missing as user conf may not need html folder
    if [ ! -d /www/html ]; then
        mkdir /www/html
        cat <<EOF > /www/html/index.nginx-debian.html
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx on Raspberry Pi Docker!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx on Raspberry Pi Docker!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a></p>

<p>
      Please use the <tt>reportbug</tt> tool to report bugs in the
      nginx package with Debian. However, check <a
      href="http://bugs.debian.org/cgi-bin/pkgreport.cgi?ordering=normal;archive=0;src=nginx;repeatmerged=0">existing
      bug reports</a> before reporting a new bug.
</p>

<p><em>Thank you for using debian and nginx.</em></p>


</body>
</html>
EOF
    fi
fi

if [ ! -d $fail2banConfDir ]; then
    mkdir $fail2banConfDir
    cp -rn /etc/fail2ban/* $fail2banConfDir
    sed -i -e "s#logtarget = .*#logtarget = STDERR/#g" $fail2banConfDir/fail2ban.conf
    cat <<EOF > $fail2banConfDir/jail.d/ssh.conf
[ssh]
enabled = false
EOF
    cat <<EOF > $fail2banConfDir/jail.d/nginx.conf
[nginx-http-auth]
enabled = true
EOF
fi

if [ ! -d /var/run/fail2ban ]; then
    mkdir /var/run/fail2ban
fi

# Start services
service dnsmasq start
fail2ban-client -x -c /config/fail2ban/ start
nginx -c $nginxConf -g "daemon off;"