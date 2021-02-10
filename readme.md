# Docker Youtube-DL Alpine

*Download with [**youtube-dl**](https://github.com/rg3/youtube-dl) using command line arguments or configuration files*

[![Docker Youtube-DL](https://github.com/qdm12/youtube-dl-docker/raw/master/title.png)](https://hub.docker.com/r/qmcgaw/youtube-dl-alpine/)

[![Build status](https://github.com/qdm12/ddns-updater/workflows/Buildx%20latest/badge.svg)](https://github.com/qdm12/ddns-updater/actions?query=workflow%3A%22Buildx+latest%22)
[![Docker Pulls](https://img.shields.io/docker/pulls/qmcgaw/youtube-dl-alpine.svg)](https://hub.docker.com/r/qmcgaw/youtube-dl-alpine)
[![Docker Stars](https://img.shields.io/docker/stars/qmcgaw/youtube-dl-alpine.svg)](https://hub.docker.com/r/qmcgaw/youtube-dl-alpine)
[![Docker Automated](https://img.shields.io/docker/automated/qmcgaw/youtube-dl-alpine.svg)](https://hub.docker.com/r/qmcgaw/youtube-dl-alpine)
[![Image size](https://images.microbadger.com/badges/image/qmcgaw/youtube-dl-alpine.svg)](https://microbadger.com/images/qmcgaw/youtube-dl-alpine)
[![Image version](https://images.microbadger.com/badges/version/qmcgaw/youtube-dl-alpine.svg)](https://microbadger.com/images/qmcgaw/youtube-dl-alpine)

[![GitHub last commit](https://img.shields.io/github/last-commit/qdm12/youtube-dl-docker.svg)](https://github.com/qdm12/youtube-dl-docker/issues)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/y/qdm12/youtube-dl-docker.svg)](https://github.com/qdm12/youtube-dl-docker/issues)
[![GitHub issues](https://img.shields.io/github/issues/qdm12/youtube-dl-docker.svg)](https://github.com/qdm12/youtube-dl-docker/issues)

[![Donate PayPal](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://paypal.me/qmcgaw)

## Features

- Works with command line arguments to *youtube-dl*
- Compatible with AMD64, 386, ARM v6/v7/v8 CPU architectures
- Small Docker image based on
    - [Alpine 3.12](https://alpinelinux.org)
    - [Youtube-dl](https://github.com/rg3/youtube-dl)
    - [ffmpeg 4.3.1](https://pkgs.alpinelinux.org/package/v3.10/community/x86_64/ffmpeg)
    - [Ca-Certificates](https://pkgs.alpinelinux.org/package/v3.10/main/x86_64/ca-certificates)
    - [Python 3.8.5](https://pkgs.alpinelinux.org/package/v3.10/main/x86_64/python)
- The container updates youtube-dl at launch if `-e AUTOUPDATE=yes`
- A log file of youtube-dl execution is saved at `downloads/log.txt` if `-e LOG=yes`
- Docker healthcheck downloading `https://duckduckgo.com` with `wget` every 10 minutes
- You can receive a notification on your Android device through Gotify when the *youtube-dl* has finished

## Setup

1. Run the container with

    ```bash
    docker run -d -v $(pwd)/yourdir:/downloads qmcgaw/youtube-dl-alpine \
    https://www.youtube.com/watch?v=HagVnWAeGcM \
    -o "/downloads/%(title)s.%(ext)s"
    ```

    or use [docker-compose.yml](https://github.com/qdm12/youtube-dl-docker/blob/master/docker-compose.yml) with

    ```bash
    docker-compose up -d
    ```

1. See the [youtube-dl command line options](https://github.com/rg3/youtube-dl/blob/master/README.md#options)
1. By default the container runs as user ID `1000` in order to not run as `root`.
If you encounter permission issues with your bind mounted `yourdir` directory, either:
    - Change the ownership and permission of your directory to match user id `1000`:

        ```sh
        chown 1000 yourdir && chmod 700 yourdir
        ```

    - Run the container with the user ID owning `yourdir`, for example with the Docker flag `--user=1030`.

### Environment variables

| Environment variable | Default | Description |
| --- | --- | --- |
| `LOG` | `yes` | Writes youtube-dl output to `/downloads/log.txt` or not |
| `AUTOUPDATE` | `no` | Updates youtube-dl to the latest version at launch |
| `GOTIFYURL` |  | Gotify server URL address (i.e. `http://192.168.1.5:8000` or `https://a.com/gotify`) |
| `GOTIFYTOKEN` |  | Gotify server Token |

### Downloads directory permission issues

You can either:

- Change the ownership and permissions of `./downloads` on your host with:

    ```sh
    chown 1000 -R ./downloads
    chmod 700 ./downloads
    chmod -R 600 ./downloads/*
    ```

- Launch the container as `root` user using `--user=root`

## TODOs

- [ ] Healthcheck to check ydl logs
- [ ] Colors in terminal
