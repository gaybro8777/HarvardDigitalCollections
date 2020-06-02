#!/bin/bash
#This script forces the db migrate to run on the database

set -e

bundle exec rake db:migrate

exec "$@"