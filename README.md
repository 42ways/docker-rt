# docker-rt

[RT](https://www.bestpractical.com/rt/), or Request Tracker, is a issue tracking system.

## Features

In this first build this container makes some assuptions that might not be for everyone. The database used is Postgresql. You have to use SSL and add the following files at startup:

* RT_SiteConfig.pm
* server-chain.pem
* server.pem

## Usage

To run docker-rt (change to your full path to files specified above):

        docker run -ti -p 443:443 -e RT_HOSTNAME=rt.example.com -v /<full path>/docker-rt/files:/data --name rt -d reuteras/docker-rt

## TODO
Lots of things.

* Update README with information on how to init and update the database
* Solution for adding plugins
