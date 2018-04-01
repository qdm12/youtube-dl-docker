# Docker Youtube-DL

Download with [**youtube-dl**](https://github.com/rg3/youtube-dl) using command line arguments or configuration files. GeoIP built on top if you use a VPN.

[![Docker Youtube-DL](https://github.com/qdm12/youtube-dl-docker/raw/master/readme/title.png)](https://hub.docker.com/r/qmcgaw/youtube-dl-alpine/)

[![Build Status](https://travis-ci.org/qdm12/youtube-dl-docker.svg?branch=master)](https://travis-ci.org/qdm12/youtube-dl-docker)

[![](https://images.microbadger.com/badges/image/qmcgaw/youtube-dl-alpine.svg)](https://microbadger.com/images/qmcgaw/youtube-dl-alpine)
[![](https://images.microbadger.com/badges/version/qmcgaw/youtube-dl-alpine.svg)](https://microbadger.com/images/qmcgaw/youtube-dl-alpine)

| Download size | Image size | RAM usage | CPU usage |
| --- | --- | --- | --- |
| 33.9MB | 93.9MB | Depends | Depends |

This image is based on the lightweight Alpine Linux with the following:
- Bash *to check for regular expressions*
- Python *to run Youtube-DL*
- Youtube-DL *without PIP*
- Curl *to update to the latest youtube-dl at each run*
- FFMPEG *to convert videos and musics*

## Installation

[![Docker container](https://github.com/qdm12/youtube-dl-docker/raw/master/readme/docker.png)](https://www.docker.com/)

1. On your host machine, create the following:
    - The output directory `mydownloads`
    - If you want to use the youtube-dl configuration file, `youtube-dl.conf` (see [this](https://github.com/rg3/youtube-dl/blob/master/README.md#configuration) for more information)
        - Note that the files will be output to `mydownloads` (see [script.sh](https://github.com/qdm12/youtube-dl-docker/blob/master/script.sh))

### With configuration files

Launch the Docker container from the image (replace the environment variables below with your own values):

```bash
sudo docker run -d --name=youtubedl -v /mypathto/mydownloads:/downloads \
-v /mypathto/youtube-dl.conf:/etc/youtube-dl.conf  qmcgaw/youtube-dl-alpine
```

- The mount `/mypathto/mydownloads:/downloads` is required.
- The mount `/mypathto/youtube-dl.conf:/etc/youtube-dl.conf` is compulsory **if** you don't use any command lines arguments.

### With command line arguments

Launch the Docker container from the image (replace the environment variables below with your own values):

```bash
sudo docker run -d --name=youtubedl -v /mypathto/mydownloads:/downloads  \
qmcgaw/youtube-dl-alpine --ignore-errors --restrict-filenames \
-a "/downloads/list.txt"
```

- The mount `/mypathto/mydownloads:/downloads` is required.
- You can pass youtube-dl arguments at the end of the docker command. See [this](https://github.com/rg3/youtube-dl/blob/master/README.md#options) to see all possible options.

### VPN and IP address check

If you want to route the traffic through another container connected to a VPN (such as my [PIA VPN container](https://github.com/qdm12/private-internet-access-docker)), 
you might want to check your VPN container works before starting downloading files.

To do so, you can set the optional environment variable `VPNCOUNTRY` to the ISO-3166 alpha2 code of your VPN country (see [the full list of codes](http://www.geonames.org/countries/))

The starting script of the container will check if the IP address match this country code and will abort if it mismatches.

You could use the command similarly to the following:

```bash
sudo docker run -d --rm --name=youtubedl --net=container:myvpn \
-e VPNCOUNTRY=UK -v '/pathto/mydownloads:/downloads' ydl
```
