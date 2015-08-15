#!/bin/bash

set -e

cp /data/RT_SiteConfig.pm /opt/rt4/etc/RT_SiteConfig.pm
chown rt-service:www-data /opt/rt4/etc/RT_SiteConfig.pm
chmod 0640 /opt/rt4/etc/RT_SiteConfig.pm

cp /data/server.pem /etc/lighttpd/server.pem
chmod 0400 /etc/lighttpd/server.pem
chown root:root /etc/lighttpd/server.pem


cp /data/server-chain.pem /etc/lighttpd/server-chain.pem
chmod 0400 /etc/lighttpd/server-chain.pem
chown root:root /etc/lighttpd/server-chain.pem

if [[ -z  "$RT_HOSTNAME" ]]; then
    echo >&2 "You must specify RT_HOSTNAME."
    exit 1
fi

sed -i -e "s=HOSTNAME=$RT_HOSTNAME=" /etc/lighttpd/conf-available/89-rt.conf

exec "$@"
