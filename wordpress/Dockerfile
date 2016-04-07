FROM wp-nginx:latest

ENV DEBIAN_FRONTEND noninteractive

# install wordpress
RUN \
  cd /usr/share/nginx/ && \
  wget -O wordpress.tar.gz https://wordpress.org/wordpress-4.4.2.tar.gz && \
  tar -xvzf wordpress.tar.gz && \
  rm wordpress.tar.gz && \
  rm -rf /usr/share/nginx/www/* && \
  mv /usr/share/nginx/html/5* /usr/share/nginx/wordpress

ADD wp_content_load.sh /nginx_content_load.sh
ADD wp_configure.sh /wp_configure.sh

# setup environment
RUN \
  echo "export TERM=xterm" >> ~/.profile && \
  echo "export TERM=xterm" >> ~/.bashrc && \
  chmod 755 /wp_*.sh && chmod 755 /nginx_*.sh

WORKDIR /
EXPOSE 80 443
VOLUME ["/usr/share/nginx/www/", "/var/cache/nginx/"]

ENTRYPOINT /nginx_start.sh
