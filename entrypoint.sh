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
[ "$AUTOUPDATE" = "no" ] || youtube-dl -U
YTDL_VERSION=$(youtube-dl --version)
PYTHON_VERSION=$(python --version 2>&1 | cut -d " " -f 2)
FFMPEG_VERSION=$(ffmpeg -version | head -n 1 | grep -oE 'version [0-9]+\.[0-9]+\.[0-9]+' | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
printf "Youtube-dl version: $YTDL_VERSION"
printf "\nPython version: $PYTHON_VERSION"
printf "\nFFMPEG version: $FFMPEG_VERSION"
printf "\n\n"
if [ "$LOG" = "yes" ]; then
  youtube-dl "$@" 2>&1 | tee downloads/log.txt
else
  youtube-dl "$@"
fi
status=$?
printf "\n =========================================\n"
printf " Youtube-dl exit with status $status\n"
printf " =========================================\n"
