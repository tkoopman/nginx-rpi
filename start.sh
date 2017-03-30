#!/bin/bash
set -e

confDir=/config
nginxConf=$confDir/nginx.conf

if [ ! -f $nginxConf ]; then
    # Config file missing
    cp -rn /etc/nginx/* $confDir
    sed -i -e "s#/etc/nginx/#$confDir/#g" $nginxConf
    sed -i -e "s#/var/www/#/www/#g" $confDir/sites-available/default
    rm -f $confDir/sites-enabled/*
    ln -s ../sites-available/default $confDir/sites-enabled/default
    
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

# Start services
service dnsmasq start
service fail2ban force-start
nginx -c $nginxConf -g "daemon off;"