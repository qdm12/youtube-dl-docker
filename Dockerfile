ARG ALPINE_VERSION=3.8

FROM alpine:${ALPINE_VERSION}
ARG BUILD_DATE
ARG VCS_REF
ARG YOUTUBE_DL_OVERWRITE=2018.11.23
LABEL org.label-schema.schema-version="1.0.0-rc1" \
      maintainer="quentin.mcgaw@gmail.com" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/qdm12/youtube-dl-docker" \
      org.label-schema.url="https://github.com/qdm12/youtube-dl-docker" \
      org.label-schema.vcs-description="Download with youtube-dl using command line arguments or configuration files" \
      org.label-schema.vcs-usage="https://github.com/qdm12/youtube-dl-docker/blob/master/README.md#setup" \
      org.label-schema.docker.cmd="docker run -d -v ./downloads:/downloads qmcgaw/youtube-dl-alpine https://www.youtube.com/watch?v=HagVnWAeGcM" \
      org.label-schema.docker.cmd.devel="docker run -it -v ./downloads:/downloads qmcgaw/youtube-dl-alpine https://www.youtube.com/watch?v=HagVnWAeGcM" \
      org.label-schema.docker.params="LOG=yes or no" \
      image-size="93.8MB" \
      ram-usage="Variable" \
      cpu-usage="Variable"
VOLUME /downloads
HEALTHCHECK --interval=10m --timeout=10s --retries=1 CMD [ "$(wget -qO- https://duckduckgo.com 2>/dev/null)" != "" ] || exit 1
ENV LOG=yes \
    AUTOUPDATE=no
ENTRYPOINT ["/entrypoint.sh"]
CMD ["-h"]
COPY entrypoint.sh /
RUN apk add -q --progress --update --no-cache ca-certificates wget ffmpeg python gnupg && \
    LATEST=$(wget -qO- https://api.github.com/repos/rg3/youtube-dl/releases/latest | grep '"tag_name": ' | sed -E 's/.*"([^"]+)".*/\1/') && \
    LATEST=${YOUTUBE_DL_OVERWRITE:-$LATEST} && \
    wget -q https://github.com/rg3/youtube-dl/releases/download/$LATEST/youtube-dl -O /usr/local/bin/youtube-dl && \
    wget -q https://github.com/rg3/youtube-dl/releases/download/$LATEST/youtube-dl.sig -O /tmp/youtube-dl.sig && \
    gpg --keyserver keyserver.ubuntu.com --recv-keys 'ED7F5BF46B3BBED81C87368E2C393E0F18A9236D' && \
    gpg --verify /tmp/youtube-dl.sig /usr/local/bin/youtube-dl && \
    SHA256=$(wget -qO- https://github.com/rg3/youtube-dl/releases/download/$LATEST/SHA2-256SUMS | head -n 1 | cut -d " " -f 1) && \
    [ $(sha256sum /usr/local/bin/youtube-dl | cut -d " " -f 1) = "$SHA256" ] && \
    apk del gnupg wget && \
    rm -rf /var/cache/apk/* /tmp/youtube-dl.sig && \
    chown 1000 /entrypoint.sh /usr/local/bin/youtube-dl && \
    chmod 500 /entrypoint.sh && \
    chmod 700 /usr/local/bin/youtube-dl
USER 1000
