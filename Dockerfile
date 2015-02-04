# heavily based on https://github.com/kencochrane/django-docker/blob/master/Dockerfile
FROM ubuntu:12.04
RUN apt-get -qq update
RUN apt-get install -y python-pip supervisor python-dev libpcre3-dev
RUN pip install virtualenv && pip install uwsgi && pip install supervisor-stdout
RUN virtualenv --no-site-packages /opt/ve/proprio
ADD docker/supervisor.conf /opt/supervisor.conf
ADD docker/run.sh /usr/local/bin/run
ADD requirements.txt /tmp/proprio-requirements.txt
RUN /opt/ve/proprio/bin/pip install -r /tmp/proprio-requirements.txt
ADD . /opt/apps/proprio
RUN (cd /opt/apps/proprio && /opt/ve/proprio/bin/python manage.py collectstatic --noinput)
# add additional_settings last because it prevents manage.py from running
ADD docker/additional_settings.py /opt/apps/proprio/additional_settings.py
RUN adduser --gecos 'user to run the app' --system proprio
EXPOSE 8000
CMD ["/bin/sh", "-e", "/usr/local/bin/run"]
