#!/bin/bash
set -x

USER=digitalcoin

chown -R ${USER} .

cd /opt/single-api
pm2 start /opt/single-api/index.js --name SINGLE-API

cron && exec gosu ${USER} "$@"
