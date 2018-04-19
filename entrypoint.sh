#!/bin/sh

# Updating youtube-dl
wget -q https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
chmod +x /usr/local/bin/youtube-dl

# Checking for configuration files if necessary
if [ ! -z "$1" ]; then
    echo "Use mode: Command line arguments"
else
    echo "Use mode: Configuration files"
    if [[ ! -f /etc/youtube-dl.conf ]]; then
        >&2 echo "youtube-dl.conf could not be found";
        exit 1;
    fi
    if [ ! -f /downloads/list.txt ]; then
        >&2 echo "list.txt could not be found";
        exit 1;
    fi
fi

# Launching youtube-dl
youtube-dl "$@" -o "/downloads/%(title)s-%(duration)s.%(ext)s"