# docker-rt - 42ways fork

[RT](https://www.bestpractical.com/rt/), or Request Tracker, is a issue tracking system. Will be built with the current RT version (download from https://download.bestpractical.com/pub/rt/release/rt.tar.gz).

## Features

This Docker spec changes some of the main assumptions of the [forked version](https://github.com/reuteras/docker-rt).

The operating system is Ubuntu. The database used is MySQL.

The container only provides HTTP access (without SSL). We use an Apache reverse proxy on or host running this container to do the SSL stuff.

The container also exposes port 25 for rt-mailgate. The mail config uses RT_HOSTNAME, DOCKER_HOSTNAME and localhost as local names, so you can forward mails to rt-mailgate using the docker hostname.

You have to provide the the following files at startup:

* RT_SiteConfig.pm
* rt-aliases (will be appended to /etc/aliases to specify rt-mailgate adresses)
* htpasswd.proxy (for access control via basic authentication)

## Usage

To run docker-rt (change to your full path to files specified above):

        docker run -ti -p 80:80 -p 25:25 -e RT_HOSTNAME=rt.example.com -e RT_RELAYHOST=mail.example.com -v /<full path>/docker-rt/files:/data --name rt -d 42ways/docker-rt

* `-e DOCKER_HOSTNAME=<CDN of the server>`
* `-e RT_HOSTNAME=<RT server hostname>`
* `-e RT_RELAYHOST=<Postfix relay host>`

## TODO
Lots of things.

* Update README with information on how to init and update the database
* Solution for adding plugins
