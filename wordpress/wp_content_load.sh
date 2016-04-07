#!/bin/bash

if find /usr/share/nginx/www -maxdepth 0 -empty | read v; then
  echo "No wordpress installation present."
  echo "Installing..."
  cp -R /usr/share/nginx/wordpress/* /usr/share/nginx/www 
  chown -R www-data:www-data /usr/share/nginx/www
  echo "Configuring..."
  /wp_configure.sh
  echo "Configuration complete."
else
  echo "Existing wordpress installation found. Continuing..."
fi
