# docker-rt - 42ways fork

[RT](https://www.bestpractical.com/rt/), or Request Tracker, is a issue tracking system. Will be built with the current RT version (download from https://download.bestpractical.com/pub/rt/release/rt.tar.gz).

## Features

This Docker spec changes some of the main assumptions of the [forked version](https://github.com/reuteras/docker-rt).

The operating system is Ubuntu. The database used is MySQL.

You have to use SSL and add the following files at startup:

* RT_SiteConfig.pm
* server-chain.pem
* server.pem

## Usage

To run docker-rt (change to your full path to files specified above):

        docker run -ti -p 443:443 -e RT_HOSTNAME=rt.example.com -e RT_RELAYHOST=mail.example.com -v /<full path>/docker-rt/files:/data --name rt -d 42ways/docker-rt

* `-e RT_HOSTNAME=<RT server hostname>`
* `-e RT_RELAYHOST=<Postfix relay host>`

## TODO
Lots of things.

* Update README with information on how to init and update the database
* Solution for adding plugins
