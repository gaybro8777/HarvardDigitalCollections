#!/bin/bash
#This script forces the db migrate to be run on the local mysql container
source /home/app/webapp/.env

RAILS_ENV=production bundle exec rake assets:precompile