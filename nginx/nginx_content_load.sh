#!/bin/bash

if find /usr/share/nginx/www -maxdepth 0 -empty | read v; then
  echo "No www content present."
  echo "Installing..."
  cp -R /usr/share/nginx/html/* /usr/share/nginx/www 
  chown -R www-data:www-data /usr/share/nginx/www
else
  echo "Existing nginx content found. Continuing..."
fi
