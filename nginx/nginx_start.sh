#!/bin/bash

echo "******************"
echo Using environment:
echo "******************"
env
echo "******************"
echo

/nginx_content_load.sh

h=${HOST:-localhost}
echo Using $h as nginx host
sed -i "s/\tserver_name localhost\;/\tserver_name $h\;/" /etc/nginx/sites-available/default

echo
echo "Starting php5-fpm..."
/usr/sbin/php5-fpm -D -R
echo "Starting nginx..."
/usr/sbin/nginx -g "daemon off;"
