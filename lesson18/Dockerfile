FROM nginx:latest
RUN mkdir /www && mkdir /www/web1.docker.io && mkdir /www/web2.docker.io && rm /etc/nginx/conf.d/default.conf
COPY conf/* /etc/nginx/conf.d/
COPY web1.docker.io/* /www/web1.docker.io/
COPY web2.docker.io/* /www/web2.docker.io/
VOLUME  /www
VOLUME /var/log/nginx