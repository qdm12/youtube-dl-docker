FROM alpine:3.7
LABEL maintainer="quentin.mcgaw@gmail.com" \
      description="Download with youtube-dl using command line arguments or configuration files. GeoIP built on top if you use a VPN" \
      download="33.9MB" \
      size="93.9MB" \
      ram="Depends" \
      cpu_usage="Depends" \
      github="https://github.com/qdm12/youtube-dl-docker"
COPY script.sh /
RUN apk add -q --progress --update --no-cache ffmpeg curl bash python && \
    curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl && \
    mkdir /downloads && \
    rm -rf /var/cache/apk/*
ENTRYPOINT /script.sh
CMD [""]