#!/bin/bash
#This script forces the db migrate to run on the database

set -e

chown app:app /etc/nginx/sites-enabled/webapp.conf
bundle exec rake db:migrate
chown -R app:app /home/app/webapp/log

exec "$@"