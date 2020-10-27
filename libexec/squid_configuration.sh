#!/bin/bash

set -euo pipefail

export DIR=$(cd `dirname $0`; cd ..; pwd)

if [ ! -d "/usr/local/var/cache/squid/ssl_db" ]; then
  /usr/local/Cellar/squid/4.13/libexec/security_file_certgen -c -s /usr/local/var/cache/squid/ssl_db -M 4MB
fi

if [ ! -f "${DIR}/etc/squid/squid.pem" ]; then
  openssl req -newkey rsa:4096 -x509 -keyout ${DIR}/etc/squid/squid.pem -out ${DIR}/etc/squid/squid.pem -days 365 -nodes -batch -subj "/CN=foo"
  chmod 400 ${DIR}/etc/squid/squid.pem
fi

/usr/local/sbin/squid -f ${DIR}/etc/squid/squid.conf -z 2>&1
