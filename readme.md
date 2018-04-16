# Docker Youtube-DL with VPN check (Alpine)

Download with [**youtube-dl**](https://github.com/rg3/youtube-dl) using command line arguments or configuration files. GeoIP built on top if you use a VPN.

[![Docker Youtube-DL](https://github.com/qdm12/youtube-dl-docker/raw/master/readme/title.png)](https://hub.docker.com/r/qmcgaw/youtube-dl-alpine/)

Youtube-dl build (external):

[![Build Status](https://travis-ci.org/rg3/youtube-dl.svg?branch=master)](https://travis-ci.org/rg3/youtube-dl)

Docker build:

[![Build Status](https://travis-ci.org/qdm12/youtube-dl-docker.svg?branch=master)](https://travis-ci.org/qdm12/youtube-dl-docker)
[![Docker Build Status](https://img.shields.io/docker/build/qmcgaw/youtube-dl-alpine.svg)](https://hub.docker.com/r/qmcgaw/youtube-dl-alpine)

[![GitHub last commit](https://img.shields.io/github/last-commit/qdm12/youtube-dl-docker.svg)](https://github.com/qdm12/youtube-dl-docker/issues)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/y/qdm12/youtube-dl-docker.svg)](https://github.com/qdm12/youtube-dl-docker/issues)
[![GitHub issues](https://img.shields.io/github/issues/qdm12/youtube-dl-docker.svg)](https://github.com/qdm12/youtube-dl-docker/issues)

[![Docker Pulls](https://img.shields.io/docker/pulls/qmcgaw/youtube-dl-alpine.svg)](https://hub.docker.com/r/qmcgaw/youtube-dl-alpine)
[![Docker Stars](https://img.shields.io/docker/stars/qmcgaw/youtube-dl-alpine.svg)](https://hub.docker.com/r/qmcgaw/youtube-dl-alpine)
[![Docker Automated](https://img.shields.io/docker/automated/qmcgaw/youtube-dl-alpine.svg)](https://hub.docker.com/r/qmcgaw/youtube-dl-alpine)

[![](https://images.microbadger.com/badges/image/qmcgaw/youtube-dl-alpine.svg)](https://microbadger.com/images/qmcgaw/youtube-dl-alpine)
[![](https://images.microbadger.com/badges/version/qmcgaw/youtube-dl-alpine.svg)](https://microbadger.com/images/qmcgaw/youtube-dl-alpine)

| Download size | Image size | RAM usage | CPU usage |
| --- | --- | --- | --- |
| 30.4MB | 89MB | Depends | Depends |

It is based on:
- [Alpine 3.7](https://alpinelinux.org)
- [ffmpeg](https://pkgs.alpinelinux.org/package/edge/community/x86_64/ffmpeg)
- [Python2](https://pkgs.alpinelinux.org/package/edge/main/x86_64/python2)
- [Ca-Certificates](https://pkgs.alpinelinux.org/package/edge/main/x86_64/ca-certificates) for the initial check and healthcheck (through HTTPS)

Youtube-DL (1.5MB) is downloaded through HTTPS each time the container starts to always have the latest updated version.

## Setup

On your Docker host, create the following:
- The output directory `/yourdownloadspath`
- If you want to use the youtube-dl configuration file, `/yourpath/youtube-dl.conf` (see [this](https://github.com/rg3/youtube-dl/blob/master/README.md#configuration) for more information)

### With configuration files

Enter the following (replace `yourdownloadspath` and `yourpath`):

```bash
docker run -d --name=youtubedl -v /yourdownloadspath:/downloads \
-v /yourpath/youtube-dl.conf:/etc/youtube-dl.conf:ro  qmcgaw/youtube-dl-alpine
```

Note that you can also download, edit and use [*docker-compose.yml*](https://github.com/qdm12/youtube-dl-docker/blob/master/docker-compose.yml)

### With command line arguments

In example, enter the following (replace `yourdownloadspath`):

```bash
sudo docker run -d --name=youtubedl -v /yourdownloadspath:/downloads  \
qmcgaw/youtube-dl-alpine --ignore-errors --restrict-filenames -a "/downloads/list.txt"
```

See [all possible arugments](https://github.com/rg3/youtube-dl/blob/master/README.md#options)

### If you use a VPN

If you want to route the traffic through another container connected to a VPN (such as my [PIA VPN container](https://github.com/qdm12/private-internet-access-docker)), 
you might want to check your youtube-dl container actually uses your VPN container before starting downloading files.

To do so, set the optional environment variables:
- `CITY=$(wget -qO- https://ipinfo.io/city)`
- `ORG=$(wget -qO- https://ipinfo.io/org)`

The starting script of the container will check if the the City and ISP of your VPN IP address are indeed different than your host.
If it is still the same, the program will exit at start.
This is checked every 5 minutes as a healthcheck as well, if you set both `CITY` and `ORG`.

To use this feature, launch the container with, in example:

```bash
sudo docker run -d --name=youtube-dl --net=container:myvpncontainer \
-v /yourdownloadspath:/downloads \
-v /yourpath/youtube-dl.conf:/etc/youtube-dl.conf:ro \
-e CITY=$(wget -qO- https://ipinfo.io/city) \
-e ORG=$(wget -qO- https://ipinfo.io/org) \
ydl
```
