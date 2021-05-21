#!/bin/sh
set -e
echo $(date)
echo -----
echo "$@"
echo -----

if [ "$1" == "ffmpeg" ] || [ "$1" == "ffprobe" ];then 
  exec "$@" -loglevel warning -hide_banner
else
  exec /bin/sh "$@"
fi

