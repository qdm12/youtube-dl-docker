# Docker Youtube-DL Alpine

*Download with [**youtube-dl**](https://github.com/rg3/youtube-dl) using command line arguments or configuration files*

[![Docker Youtube-DL](https://github.com/qdm12/youtube-dl-docker/raw/master/title.png)](https://hub.docker.com/r/qmcgaw/youtube-dl-alpine/)

[![Docker Build Status](https://img.shields.io/docker/build/qmcgaw/youtube-dl-alpine.svg)](https://hub.docker.com/r/qmcgaw/youtube-dl-alpine)

[![GitHub last commit](https://img.shields.io/github/last-commit/qdm12/youtube-dl-docker.svg)](https://github.com/qdm12/youtube-dl-docker/issues)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/y/qdm12/youtube-dl-docker.svg)](https://github.com/qdm12/youtube-dl-docker/issues)
[![GitHub issues](https://img.shields.io/github/issues/qdm12/youtube-dl-docker.svg)](https://github.com/qdm12/youtube-dl-docker/issues)

[![Docker Pulls](https://img.shields.io/docker/pulls/qmcgaw/youtube-dl-alpine.svg)](https://hub.docker.com/r/qmcgaw/youtube-dl-alpine)
[![Docker Stars](https://img.shields.io/docker/stars/qmcgaw/youtube-dl-alpine.svg)](https://hub.docker.com/r/qmcgaw/youtube-dl-alpine)
[![Docker Automated](https://img.shields.io/docker/automated/qmcgaw/youtube-dl-alpine.svg)](https://hub.docker.com/r/qmcgaw/youtube-dl-alpine)

[![Image size](https://images.microbadger.com/badges/image/qmcgaw/youtube-dl-alpine.svg)](https://microbadger.com/images/qmcgaw/youtube-dl-alpine)
[![Image version](https://images.microbadger.com/badges/version/qmcgaw/youtube-dl-alpine.svg)](https://microbadger.com/images/qmcgaw/youtube-dl-alpine)

[![Donate PayPal](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://paypal.me/qdm12)

| Image size | RAM usage | CPU usage |
| --- | --- | --- |
| 95.3MB | Depends | Depends |

It is based on:

- [Alpine 3.9](https://alpinelinux.org)
- [Youtube-dl](https://github.com/rg3/youtube-dl)
- [ffmpeg 3.4.4](https://pkgs.alpinelinux.org/package/v3.9/community/x86_64/ffmpeg)
- [Ca-Certificates](https://pkgs.alpinelinux.org/package/v3.9/main/x86_64/ca-certificates)
- [Python 2.7.15](https://pkgs.alpinelinux.org/package/v3.9/main/x86_64/python)

## Setup

1. Run the container with

    ```bash
    docker run -d -v $(pwd):/downloads qmcgaw/youtube-dl-alpine \
    https://www.youtube.com/watch?v=HagVnWAeGcM \
    -o "/downloads/%(title)s.%(ext)s"
    ```

    or use [docker-compose.yml](https://github.com/qdm12/youtube-dl-docker/blob/master/docker-compose.yml) with

    ```bash
    docker-compose up -d
    ```

1. See the [youtube-dl command line options](https://github.com/rg3/youtube-dl/blob/master/README.md#options)

## Extra features

- The container updates youtube-dl at launch if the environment variable is `AUTOUPDATE=yes`
- A log file of youtube-dl execution is saved at `downloads/log.txt` if the environment variable is `LOG=yes`
- A healthcheck is implemented which downloads `https://duckduckgo.com` with wget every 10 minutes
- The Docker Hub image is updated automatically every 3 days, so simply update your image with `docker pull qmcgaw\youtube-dl-alpine

### Environment variables

| Environment variable | Default | Description |
| --- | --- | --- |
| `LOG` | `yes` | Writes youtube-dl output to `/downloads/log.txt` or not |
| `AUTOUPDATE` | `no` | Updates youtube-dl to the latest version at launch |

### Downloads directory permission issues

You can either:

    - Change the ownership and permissions of `./downloads` on your host with:

        ```sh
        chown 1000 -R ./downloads
        chmod 700 ./downloads
        chmod -R 600 ./downloads/*
        ```

    - Launch the container with a different user using `--user=$UID:$GID`

## TODOs

- [ ] Healthcheck to check ydl logs
- [ ] Colors in terminal
- [ ] Notify when done