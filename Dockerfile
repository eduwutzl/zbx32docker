FROM ubuntu:latest
MAINTAINER Eduardo Wutzl

COPY run.sh /
RUN chmod a+x /run.sh

COPY packages/ /packages/

RUN dpkg -i /packages/zabbix-release_3.2-1+xenial_all.deb

RUN apt-get update && apt-get install -y \
	supervisor

COPY packages/supervisord.conf /etc/supervisor/
COPY packages/zbx.conf /etc/supervisor/conf.d/

RUN apt-get update && apt-get \
	--no-install-recommends install -y \
	zabbix-server-mysql

RUN mkdir /var/run/zabbix/ && \
	chown -R zabbix:zabbix /var/run/zabbix

COPY packages/zabbix_server.conf /etc/zabbix/


EXPOSE 10051


# Run app.py when the container launches
#CMD "/usr/bin/supervisord -c /etc/supervisor/supervisord.conf"
ENTRYPOINT ["/run.sh"]
