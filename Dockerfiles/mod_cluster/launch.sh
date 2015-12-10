#/bin/bash

# Get the IP address
#IPADDR=$(ip a s | sed -ne '/127.0.0.1/!{s/^[ \t]*inet[ \t]*\([0-9.]\+\)\/.*$/\1/p}')

# Adjust the IP addresses in the mod_cluster.conf file
#sed -i "s|[0-9\.\*]*:80|$IPADDR:80|g" /etc/httpd/conf.d/mod_cluster.conf


echo "Running mod_cluster."

# Run Apache
httpd -D FOREGROUND
