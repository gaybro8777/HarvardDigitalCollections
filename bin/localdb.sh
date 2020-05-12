#!/bin/bash
#This script forces the db migrate to be run on the local mysql container
set -e

rake db:migrate

exec "$@"