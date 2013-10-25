#!/bin/bash

# set up cron to execute this script every hour

source /home/mike/.bashrc &> /dev/null


cd /home/mike/mailer 
/usr/local/bin/node mailer.js &> log.txt &

