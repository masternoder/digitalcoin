#!/bin/bash
set -x

USER=digitalcoin

chown -R ${USER} .

cd /opt/single-api
git pull
npm update
pm2 start index.js --name SINGLE-API

cron && exec gosu ${USER} "$@"