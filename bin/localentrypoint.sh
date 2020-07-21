#!/bin/bash
#This script forces the db migrate to be run on the local mysql container

set -e

/home/app/webapp/bin/wait-for-it.sh hdc_mysql:3306

/home/app/webapp/bin/entrypoint.sh

exec "$@"