#!/bin/sh

printf " =========================================\n"
printf " =========================================\n"
printf " ========== YOUTUBE-DL CONTAINER =========\n"
printf " =========================================\n"
printf " =========================================\n"
printf " == by github.com/qdm12 - Quentin McGaw ==\n\n"

exitIfNotIn(){
  # $1 is the name of the variable to check - not the variable itself
  # $2 is a string of comma separated possible values
  var="$(eval echo "\$$1")"
  for value in ${2//,/ }
  do
    if [ "$var" = "$value" ]; then
      return 0
    fi
  done
  printf "Environment variable $1=$var must be one of the following: "
  for value in ${2//,/ }
  do
    printf "$value "
  done
  printf "\n"
  exit 1
}

exitOnError(){
  # $1 must be set to $?
  status=$1
  message=$2
  [ "$message" != "" ] || message="Error!"
  if [ $status != 0 ]; then
    printf "$message (status $status)\n"
    exit $status
  fi
}

exitIfNotIn LOG "yes,no"
exitIfNotIn AUTOUPDATE "yes,no"
test -w "/downloads"
exitOnError $? "/downloads is not writable, please fix its ownership and/or permissions"
YTDL_VERSION_BUILD=$(youtube-dl --version)
PYTHON_VERSION_BUILD=$(python --version 2>&1 | cut -d " " -f 2)
FFMPEG_VERSION_BUILD=$(ffmpeg -version | head -n 1 | grep -oE 'version [0-9]+\.[0-9]+\.[0-9]+' | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
GPG_VERSION_BUILD=$(gpg --version | head -n 1 | cut -d " " -f 3)
if [ "$UID" = "0" ] && [ "$AUTOUPDATE" = "yes" ]; then
  printf "Checking for Alpine packages updates..."
  apk -q --no-cache --update upgrade
  printf "DONE\n"
fi
if [ "$AUTOUPDATE" = "yes" ]; then
  printf "Checking for Youtube-DL update..."
  YTDL_VERSION=$(wget -qO- https://api.github.com/repos/rg3/youtube-dl/releases/latest | grep '"tag_name": ' | sed -E 's/.*"([^"]+)".*/\1/')
  if [ "$YTDL_VERSION_BUILD" != "$YTDL_VERSION" ]; then
    wget -q https://github.com/rg3/youtube-dl/releases/download/$YTDL_VERSION/youtube-dl -O /usr/local/bin/youtube-dl
    wget -q https://github.com/rg3/youtube-dl/releases/download/$YTDL_VERSION/youtube-dl.sig -O /tmp/youtube-dl.sig
    if [ gpg --verify /tmp/youtube-dl.sig /usr/local/bin/youtube-dl ]; then
      printf "error verifying youtube-dl signature!\n"
      exit 1
    fi
    SHA256=$(wget -qO- https://github.com/rg3/youtube-dl/releases/download/$YTDL_VERSION/SHA2-256SUMS | head -n 1 | cut -d " " -f 1)
    if [ $(sha256sum /usr/local/bin/youtube-dl | cut -d " " -f 1) != "$SHA256" ]; then
      printf "error verifying youtube-dl checksum!\n"
      exit 1
    fi
  fi
  printf "DONE\n"
fi
YTDL_VERSION=$(youtube-dl --version)
PYTHON_VERSION=$(python --version 2>&1 | cut -d " " -f 2)
FFMPEG_VERSION=$(ffmpeg -version | head -n 1 | grep -oE 'version [0-9]+\.[0-9]+\.[0-9]+' | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
GPG_VERSION=$(gpg --version | head -n 1 | cut -d " " -f 3)
printf "Youtube-dl version: $YTDL_VERSION"
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
printf "\n\n"
if [ "$LOG" = "yes" ]; then
  youtube-dl "$@" | tee downloads/log.txt  
else
  youtube-dl "$@"
fi
status=$?
printf "\n =========================================\n"
printf " Youtube-dl exit with status $status\n"
printf " =========================================\n"
