FROM alpine:3.7
LABEL maintainer="quentin.mcgaw@gmail.com" \
      description="Download with youtube-dl using command line arguments or configuration files. GeoIP built on top if you use a VPN" \
      download="30.4MB" \
      size="89MB" \
      ram="Depends" \
      cpu_usage="Depends" \
      github="https://github.com/qdm12/youtube-dl-docker"
RUN apk add -q --progress --update --no-cache ca-certificates ffmpeg python2 && \
    mkdir /downloads && \
    rm -rf /var/cache/apk/*
ENV CITY= \
    ORG=
VOLUME /downloads
COPY vpncheck.sh entrypoint.sh /
HEALTHCHECK --interval=5m --timeout=5s --retries=1 CMD /vpncheck.sh
ENTRYPOINT /vpncheck.sh && /entrypoint.sh
CMD [""]