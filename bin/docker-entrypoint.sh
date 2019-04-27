#!/bin/bash
set -x

USER=digitalcoin

chown -R ${USER} .
cron && exec gosu ${USER} "$@"
