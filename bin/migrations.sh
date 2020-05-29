#!/bin/bash
#This script forces the db migrate to run on the database

set -e

rake db:migrate

exec "$@"