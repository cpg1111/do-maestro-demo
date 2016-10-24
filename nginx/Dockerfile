FROM debian:jessie
RUN echo "deb https://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list && \
    apt-get -qq update && \
    apt-get install -y nginx supervisor curl && \
    mkdir -p /var/lock/nginx /var/log/supervisor
ADD https://github.com/kelseyhightower/confd/releases/download/v0.11.0/confd-0.11.0-linux-amd64 /usr/bin/confd
COPY ./confd/ /etc/confd/
COPY ./supervisord.conf /etc/supervisor/supervisord.conf
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]

