#apt-get update && apt-get upgrade

#apt-get install --assume-yes apt-transport-https git libffi-dev wget nginx vim inetutils-ping collectd collectd-utils snmpd libapr1 libaprutil1 libaprutil1-dbd-sqlite3 python3 libpython3.4 python3-minimal libaprutil1-ldap memcached python-ca iro-dev python-ldap python-memcache python-pysqlite2 python-dev sqlite3 erlang-os-mon erlang-snmp rabbitmq-server bzr expect python-setuptools sudo python-setuptools python-pip3 python gcc


python -m pip3 install --upgrade pip3 
pip3 install django==1.11.12
pip3 install whisper==1.1.3
pip3 install carbon==1.1.3
pip3 install graphite-web==1.1.3 

git clone -b 1.1.3 --depth 1 https://github.com/graphite-project/whisper.git /usr/local/src/whisper &&\
git clone -b 1.1.3 --depth 1 https://github.com/graphite-project/carbon.git /usr/local/src/carbon &&\
git clone -b 1.1.3 --depth 1 https://github.com/graphite-project/graphite-web.git /usr/local/src/graphite-web &&\
git clone -b v0.8.0 --depth 1 https://github.com/etsy/statsd.git /opt/statsd


cd /usr/local/src/whisper
python ./setup.py install

cd /usr/local/src/carbon
pip3 install -r requirements.txt && python ./setup.py install

cd /usr/local/src/graphite-web
pip3 install -r requirements.txt && python ./setup.py install


cp /home/pi/sizer/docker-graphite-statsd/conf/opt/graphite/conf/*.conf /opt/graphite/conf/
cp /home/pi/sizer/docker-graphite-statsd/conf/opt/graphite/webapp/graphite/local_settings.py /opt/graphite/webapp/graphite/local_settings.py
cd /opt/graphite/webapp
mkdir -p /var/log/graphite/ && PYTHONPATH=/opt/graphite/webapp django-admin.py collectstatic --noinput --settings=graphite.settings
cp /home/pi/sizer/docker-graphite-statsd/conf/opt/statsd/config_*.js /opt/statsd/
rm /etc/nginx/sites-enabled/default
cp /home/pi/sizer/docker-graphite-statsd/conf/etc/nginx/nginx.conf /etc/nginx/nginx.conf
cp /home/pi/sizer/docker-graphite-statsd/conf/etc/nginx/sites-enabled/graphite-statsd.conf /etc/nginx/sites-enabled/graphite-statsd.conf
cp /home/pi/sizer/docker-graphite-statsd/conf/usr/local/bin/django_admin_init.exp /usr/local/bin/django_admin_init.exp
cp /home/pi/sizer/docker-graphite-statsd/conf/usr/local/bin/manage.sh /usr/local/bin/manage.sh
chmod +x /usr/local/bin/manage.sh && /usr/local/bin/django_admin_init.exp

#Logging
mkdir -p /var/log/carbon /var/log/graphite /var/log/nginx
cp /home/pi/sizer/docker-graphite-statsd/conf/etc/logrotate.d/graphite-statsd /etc/logrotate.d/graphite-statsd

# daemons
cp /home/pi/sizer/docker-graphite-statsd/conf/etc/service/carbon/run /etc/service/carbon/run
cp /home/pi/sizer/docker-graphite-statsd/conf/etc/service/carbon-aggregator/run /etc/service/carbon-aggregator/run
cp /home/pi/sizer/docker-graphite-statsd/conf/etc/service/graphite/run /etc/service/graphite/run
cp /home/pi/sizer/docker-graphite-statsd/conf/etc/service/statsd/run /etc/service/statsd/run
cp /home/pi/sizer/docker-graphite-statsd/Dconf/etc/service/nginx/run /etc/service/nginx/run

# default conf setup
cp /home/pi/sizer/docker-graphite-statsd/conf /etc/graphite-statsd/conf
cp /home/pi/sizer/docker-graphite-statsd/conf/etc/my_init.d/01_conf_init.sh /etc/my_init.d/01_conf_init.sh

apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

