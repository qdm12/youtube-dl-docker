#!/bin/sh

set -e

if [ -z "$CITY" ] && [ -z "$ORG" ]; then
    echo "IP country check: OFF";
else
    echo "IP country check: ON";
    if [ -z "$CITY" ] || [ -z "$ORG" ]; then
        >&2 echo "Please set both CITY and ORG"
        exit 1
    else
        CURRENT_CITY=$(wget -qO- -T 2 https://ipinfo.io/city)
        CURRENT_ORG=$(wget -qO- -T 2 https://ipinfo.io/org)
        printf "Current city: $CURRENT_CITY\nCurrent organization: $CURRENT_ORG\n"
        if [ "$CITY" == "$CURRENT_CITY" ] && [ "$ORG" == "$CURRENT_ORG" ]; then
            >&2 echo "VPN does not seem to work"
            exit 1
        fi
    fi
fi
