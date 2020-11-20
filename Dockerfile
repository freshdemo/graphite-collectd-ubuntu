FROM   ubuntu
#FROM	debian:sid

# ---------------- #
#   Installation   #
# ---------------- #
WORKDIR /sizer

RUN	apt-get update && apt-get upgrade -y 				&&\
	apt-get install -y wget						

# Install all prerequisites
RUN  apt-get install --assume-yes apt-transport-https git libffi-dev wget nginx vim inetutils-ping collectd collectd-utils snmpd apache2 apache2-utils apache2-bin libapr1 libaprutil1 libaprutil1-dbd-sqlite3 python3 libpython3.4 python3-minimal libapache2-mod-wsgi libaprutil1-ldap memcached python-cairo-dev python-ldap python-memcache python-pysqlite2 python-dev sqlite3 erlang-os-mon erlang-snmp rabbitmq-server bzr expect ssh libapache2-mod-python python-setuptools sudo python-setuptools python-pip python gcc

RUN  python -m pip install --upgrade pip &&\
     pip install django==1.11.12 &&\
     pip install whisper==1.1.3 &&\
     pip install carbon==1.1.3 &&\
     pip install graphite-web==1.1.3 

RUN  git clone -b 1.1.3 --depth 1 https://github.com/graphite-project/whisper.git /usr/local/src/whisper &&\
     git clone -b 1.1.3 --depth 1 https://github.com/graphite-project/carbon.git /usr/local/src/carbon &&\
     git clone -b 1.1.3 --depth 1 https://github.com/graphite-project/graphite-web.git /usr/local/src/graphite-web &&\
     git clone -b v0.8.0 --depth 1 https://github.com/etsy/statsd.git /opt/statsd


#RUN  cp /opt/graphite/conf/carbon.conf.example /opt/graphite/conf/carbon.conf
#     cp /opt/graphite/conf/storage-schemas.conf.example /opt/graphite/conf/storage-schemas.conf.example

# Checkout the master branches of Graphite, Carbon and Whisper and install from there
#RUN     mkdir /sizer                                                                                                   &&\
#RUN 	wget https://launchpad.net/graphite/0.9/0.9.10/+download/whisper-0.9.10.tar.gz             &&\
#	tar -zxvf whisper-0.9.10.tar.gz

#RUN     wget https://launchpad.net/graphite/0.9/0.9.10/+download/carbon-0.9.10.tar.gz               &&\
#	tar -zxvf carbon-0.9.10.tar.gz 

#RUN     mkdir /sizer &&\
#        wget https://launchpad.net/graphite/0.9/0.9.10/+download/graphite-web-0.9.10.tar.gz   &&\
#        tar -zxvf graphite-web-0.9.10.tar.gz                                                  

#RUN	wget https://launchpad.net/graphite/0.9/0.9.10/+download/check-dependencies.py

EXPOSE  80
EXPOSE  8125/udp
EXPOSE  8126
EXPOSE 81
EXPOSE 2003
