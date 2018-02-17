#!/bin/bash

# VPN IP address check if necessary
if [[ ! -z "$VPNCOUNTRY" ]]; then
    echo "IP country check: ON";
    if [[ ! "${VPNCOUNTRY}" =~ ^[A-Z][A-Z]$ ]]; then
        >&2 echo "The environment variable VPNCOUNTRY is malformed. Exiting...";
        exit 1;
    fi
    country=$(curl ipinfo.io/country);
    echo "Target VPN IP country is $VPNCOUNTRY and current IP country is $country";
    if [ "$country" != "$VPNCOUNTRY" ]; then
        >&2 echo "Country is not $VPNCOUNTRY. Exiting...";
        exit 1;
    fi
else
    echo "IP country check: OFF";
fi

# Updating youtube-dl
curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl

# Checking for configuration files if necessary
if [[ -z "$1" ]]; then
    echo "Use mode: Configuration files";
    if [[ ! -f /downloads/list.txt ]]; then
        >&2 echo "list.txt could not be found. Exiting...";
        exit 1;
    fi
    if [[ ! -f /etc/youtube-dl.conf ]]; then
        >&2 echo "youtube-dl.conf could not be found. Exiting...";
        exit 1;
    fi
else
    echo "Use mode: Command line arguments"
fi

# Launching youtube-dl
youtube-dl "$@" -o "/downloads/%(title)s-%(duration)s.%(ext)s"