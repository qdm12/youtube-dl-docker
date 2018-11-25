# Docker Youtube-DL Alpine

*Download with [**youtube-dl**](https://github.com/rg3/youtube-dl) using command line arguments or configuration files*

[![Docker Youtube-DL](https://github.com/qdm12/youtube-dl-docker/raw/master/title.png)](https://hub.docker.com/r/qmcgaw/youtube-dl-alpine/)

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
- [GnuPG 2.2.8](https://pkgs.alpinelinux.org/package/v3.8/main/x86_64/gnupg)

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

- The container checks for youtube-dl latest release and self-updates at launch
- A log file of youtube-dl execution is saved at `downloads/log.txt` if the environment variable `LOG=yes`
- A healthcheck is implemented which downloads `https://duckduckgo.com` with wget

### Environment variables

| Environment variable | Default | Description |
| --- | --- | --- |
| `LOG` | `yes` | Writes youtube-dl output to `/downloads/log.txt` or not |
| `AUTOUPDATE` | `yes` | Updates youtube-dl and other packages at launch or not |

### Auto update Alpine packages

Although unsecured, you can run the container with `--user=root` to auto update Alpine packages at start such as

- Python 2.7
- FFMPEG
- GNUPG

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
- [ ] Regular automated builds
- [ ] Colors in terminal
- [ ] Notify when done