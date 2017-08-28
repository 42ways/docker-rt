FROM ubuntu
MAINTAINER Thomas Herrmann <thomas@42ways.de>

# Config Postfix
RUN echo mail > /etc/hostname; \
    echo "postfix postfix/main_mailer_type string Internet site" > \
        preseed.txt && \
    echo "postfix postfix/mailname string mail.example.com" >> \
        preseed.txt && \
    debconf-set-selections preseed.txt

## Install tools and libraries
RUN apt-get update -yqq && \
    apt-get install -yqq --no-install-recommends \
        build-essential \
        ca-certificates \
        cpanminus \
        curl \
        git \
        gpgv2 \
        graphviz \
        libexpat1-dev \
        libpq-dev \
        libgd-dev \
        lighttpd \
        perl \
        postfix \
        mysql-client \
        libmysqlclient-dev \
        tzdata \
        supervisor && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/

# Create user and group
RUN groupadd -r rt-service && \
    useradd -r -g rt-service -G www-data rt-service && \
    usermod -a -G rt-service www-data

# Perl settings -n to don't to tests
ENV RT_FIX_DEPS_CMD /usr/bin/cpanm
ENV PERL_CPANM_OPT -n

RUN mkdir -p --mode=770 /opt/rt4/var/data/RT-Shredder && \
    mkdir -p /tmp/rt && \
    curl -SL https://download.bestpractical.com/pub/rt/release/rt.tar.gz | \
        tar -xzC /tmp/rt && \
    cd /tmp/rt/rt* && \
    echo "o conf init " | \
        perl -MCPAN -e shell && \
    ./configure \
        --enable-graphviz \
        --enable-gd \
        --enable-gpg \
        --with-web-handler=fastcgi \
        --with-bin-owner=rt-service \
        --with-libs-owner=rt-service \
        --with-libs-group=www-data \
        --with-db-type=mysql \
        --with-web-user=www-data \
        --with-web-group=www-data \
        --prefix=/opt/rt4 \
        --with-rt-group=rt-service && \
    make fixdeps && \
    make testdeps && \
    make config-install dirs files-install fixperms instruct && \
    cpanm git://github.com/gbarr/perl-TimeDate.git && \
    chown rt-service:www-data /opt/rt4

# Clean up
RUN apt-get remove -y build-essential && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /tmp/rt && \
    rm -rf /root/.cpan && \
    rm -rf /root/.cpanm

# Copy files to docker
COPY entrypoint.sh /entrypoint.sh
COPY 89-rt.conf /etc/lighttpd/conf-available/89-rt.conf
COPY supervisord.conf /etc/supervisor/supervisord.conf

RUN chmod +x /entrypoint.sh && \
    /usr/sbin/lighty-enable-mod rt && \
    chmod 770 /opt/rt4/etc && \
    chmod 660 /opt/rt4/etc/RT_SiteConfig.pm && \
    chown -R rt-service:www-data /opt/rt4/var && \
    chown -R www-data:www-data /opt/rt4/var/data && \
    chmod 770 /opt/rt4/var /opt/rt4/var/log /opt/rt4/var/data /opt/rt4/var/data/RT-Shredder

EXPOSE 80
EXPOSE 25

VOLUME /data

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
