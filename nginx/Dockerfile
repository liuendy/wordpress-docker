FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive

# install basics
RUN \
  apt-get update && \
  apt-get install -y unzip less dnsutils net-tools vim curl wget software-properties-common jq sysstat htop 

# install php
RUN \
  apt-get -y install php5-mysql php5-fpm php5-gd php5-cli

# install nginx
#ENV NGINX_VERSION 1.8.1-1~trusty
#RUN \
#  apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 && \
#  echo "deb http://nginx.org/packages/ubuntu/ trusty nginx" >> /etc/apt/sources.list && \
#  apt-get update && \
#  apt-get install -y ca-certificates nginx=${NGINX_VERSION} 
RUN \
  apt-get install -y nginx

# clean apt-get
RUN \
  rm -rf /var/lib/apt/lists/* && \
  apt-get clean

# configure phpfpm settings
RUN \
  sed -i "s/^;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php5/fpm/php.ini && \
  sed -i "s/^;listen.owner = www-data/listen.owner = www-data/" /etc/php5/fpm/pool.d/www.conf && \
  sed -i "s/^;listen.group = www-data/listen.group = www-data/" /etc/php5/fpm/pool.d/www.conf && \
  sed -i "s/^;listen.mode = 0660/listen.mode = 0660/" /etc/php5/fpm/pool.d/www.conf 

# configure nginx
ADD nginx-default /etc/nginx/sites-available/default
#ADD nginx.conf /etc/nginx/nginx.conf
ADD nginx_content_load.sh /nginx_content_load.sh
ADD nginx_start.sh /nginx_start.sh
RUN \
  mkdir -p /var/cache/nginx/fastcgi && \
  chown -R www-data:www-data /var/cache/nginx && \
  chmod 755 /nginx_*.sh 
  #sed -i "s/\/usr\/share\/nginx\/html/\/usr\/share\/nginx\/www/" /etc/nginx/conf.d/default.conf && \
  #sed -i "s/index  index.html index.htm/index  index.php index.html index.html/" /etc/nginx/conf.d/default.conf && \ 
  #mkdir /etc/nginx/sites-enabled/ && \
  #ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default.conf

# setup environment
RUN \
  echo "export TERM=xterm" >> ~/.profile && \
  echo "export TERM=xterm" >> ~/.bashrc 

WORKDIR /
EXPOSE 80 443
VOLUME ["/usr/share/nginx/www/", "/var/cache/nginx/"]

ENTRYPOINT /nginx_start.sh
