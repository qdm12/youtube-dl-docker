#!/bin/sh

printf "\n ========================================="
printf "\n ========================================="
printf "\n ========== YOUTUBE-DL CONTAINER ========="
printf "\n ========================================="
printf "\n ========================================="
printf "\n == by github.com/qdm12 - Quentin McGaw ==\n\n"

YTDL_VERSION_BUILD=$(youtube-dl --version)
PYTHON_VERSION_BUILD=$(python --version 2>&1 | cut -d " " -f 2)
FFMPEG_VERSION_BUILD=$(ffmpeg -version | head -n 1 | grep -oE 'version [0-9]+\.[0-9]+\.[0-9]+' | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
GPG_VERSION_BUILD=$(gpg --version | head -n 1 | cut -d " " -f 3)
printf "Checking for Alpine packages updates..."
apk -q --no-cache --update upgrade
printf "DONE\n"
printf "Checking for Youtube-DL update..."
YTDL_VERSION=$(wget -qO- https://api.github.com/repos/rg3/youtube-dl/releases/latest | grep '"tag_name": ' | sed -E 's/.*"([^"]+)".*/\1/')
if [ "$YTDL_VERSION_BUILD" != "$YTDL_VERSION" ]; then
  wget -q https://github.com/rg3/youtube-dl/releases/download/$YTDL_VERSION/youtube-dl -O /usr/local/bin/youtube-dl
  wget -q https://github.com/rg3/youtube-dl/releases/download/$YTDL_VERSION/youtube-dl.sig -O /tmp/youtube-dl.sig
  [ gpg --verify /tmp/youtube-dl.sig /usr/local/bin/youtube-dl ] && (printf "error verifying youtube-dl signature!"; exit 1)
  SHA256=$(wget -qO- https://github.com/rg3/youtube-dl/releases/download/$YTDL_VERSION/SHA2-256SUMS | head -n 1 | cut -d " " -f 1)
  [ $(sha256sum /usr/local/bin/youtube-dl | cut -d " " -f 1) != "$SHA256" ] && (printf "error verifying youtube-dl checksum!"; exit 1)
  chmod 700 /usr/local/bin/youtube-dl
fi
printf "DONE"
YTDL_VERSION=$(youtube-dl --version)
PYTHON_VERSION=$(python --version 2>&1 | cut -d " " -f 2)
FFMPEG_VERSION=$(ffmpeg -version | head -n 1 | grep -oE 'version [0-9]+\.[0-9]+\.[0-9]+' | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
GPG_VERSION=$(gpg --version | head -n 1 | cut -d " " -f 3)
printf "\nYoutube-dl version: $YTDL_VERSION"
if [ "$YTDL_VERSION" != "$YTDL_VERSION_BUILD" ]; then
  printf " (updated from $YTDL_VERSION_BUILD)"
fi
printf "\nPython version: $PYTHON_VERSION"
if [ "$PYTHON_VERSION" != "$PYTHON_VERSION_BUILD" ]; then
  printf " (updated from $PYTHON_VERSION_BUILD)"
fi
printf "\nFFMPEG version: $FFMPEG_VERSION"
if [ "$FFMPEG_VERSION" != "$FFMPEG_VERSION_BUILD" ]; then
  printf " (updated from $FFMPEG_VERSION_BUILD)"
fi
printf "\nGPG version: $GPG_VERSION"
if [ "$GPG_VERSION" != "$GPG_VERSION_BUILD" ]; then
  printf " (updated from $GPG_VERSION_BUILD)"
fi
# Checking for configuration files if necessary
if [ "$1" != "" ]; then
  printf "\nUsing arguments: '$@'\n"
else
  printf "\nUsing configuration file /etc/youtube-dl.conf..."
  if [ ! -f /etc/youtube-dl.conf ]; then
    >&2 echo "not found !"
    exit 1
  fi
fi
youtube-dl "$@"
status=$?
printf "\n ========================================="
printf "\n Youtube-dl exit with status $status"
printf "\n =========================================\n"
