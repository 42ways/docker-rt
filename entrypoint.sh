#!/bin/bash

set -e

cp /data/RT_SiteConfig.pm /opt/rt4/etc/RT_SiteConfig.pm
chown rt-service:www-data /opt/rt4/etc/RT_SiteConfig.pm
chmod 0640 /opt/rt4/etc/RT_SiteConfig.pm

if [ -d /data/local ]
then
    cp -r /data/local /opt/rt4
    chown -R rt-service:www-data /opt/rt4/local
fi

if [[ -z  "$RT_HOSTNAME" ]]; then
    echo >&2 "You must specify RT_HOSTNAME."
    exit 1
fi

if [[ -z  "$RT_RELAYHOST" ]]; then
    echo >&2 "You must specify RT_RELAYHOST."
    exit 1
fi

sed -i -e "s=HOSTNAME=$RT_HOSTNAME=" /etc/lighttpd/conf-available/89-rt.conf

cat /data/rt-aliases >> /etc/aliases
newaliases

cat >> /opt/postfix.sh <<EOF
#!/bin/bash
service postfix start
touch /var/log/mail.log
tail -f /var/log/mail.log
EOF

chmod +x /opt/postfix.sh

postconf -e myhostname=$RT_HOSTNAME
postconf -e inet_interfaces=loopback-only
postconf -e inet_protocols=ipv4
postconf -e mydestination=$RT_HOSTNAME,localhost
postconf -e myhostname=$RT_HOSTNAME
postconf -e mynetworks=127.0.0.0/8
postconf -e relayhost=$RT_RELAYHOST

exec "$@"
