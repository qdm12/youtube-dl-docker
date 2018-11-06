# Docker Youtube-DL Alpine

*Download with [**youtube-dl**](https://github.com/rg3/youtube-dl) using command line arguments or configuration files*

[![Docker Youtube-DL](https://github.com/qdm12/youtube-dl-docker/raw/master/title.png)](https://hub.docker.com/r/qmcgaw/youtube-dl-alpine/)

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

[![Image size](https://images.microbadger.com/badges/image/qmcgaw/youtube-dl-alpine.svg)](https://microbadger.com/images/qmcgaw/youtube-dl-alpine)
[![Image version](https://images.microbadger.com/badges/version/qmcgaw/youtube-dl-alpine.svg)](https://microbadger.com/images/qmcgaw/youtube-dl-alpine)

| Image size | RAM usage | CPU usage |
| --- | --- | --- |
| 100MB | Depends | Depends |

It is based on:

- [Alpine 3.8](https://alpinelinux.org)
- [Youtube-dl](https://github.com/rg3/youtube-dl)
- [ffmpeg 3.4.4](https://pkgs.alpinelinux.org/package/v3.8/community/x86_64/ffmpeg)
- [Ca-Certificates](https://pkgs.alpinelinux.org/package/v3.8/main/x86_64/ca-certificates) for the initial check and healthcheck (through HTTPS)
- [Python 2.7.15](https://pkgs.alpinelinux.org/package/v3.8/main/x86_64/python)
- GnuPG 2.2.8

## Setup

See the [youtube-dl command line options](https://github.com/rg3/youtube-dl/blob/master/README.md#options)

Use the following command in example:


```bash
docker run -d -v /yourpath:/downloads qmcgaw/youtube-dl-alpine https://www.youtube.com/watch?v=HagVnWAeGcM -o "/downloads/%(title)s-%(duration)s.%(ext)s"
```

if you want to use a youtube-dl configuration file `youtube-dl.conf`, use:


```bash
docker run -d -v /yourpath:/downloads \
-v ./youtube-dl.conf:/etc/youtube-dl.conf:ro \
qmcgaw/youtube-dl-alpine https://www.youtube.com/watch?v=HagVnWAeGcM
```


or use [docker-compose.yml](https://github.com/qdm12/youtube-dl-docker/blob/master/docker-compose.yml) with:


```bash
docker-compose up -d
```

## Other

- A healthcheck is implemented which only check DNS lookup of `duckduckgo.com` works
- The container self-updates at start which is essential to have an up-to-date youtube-dl program

## TODOs

- Env variables
- Colors in terminal
- Regular automated builds
