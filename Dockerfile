ARG ALPINE_VERSION=3.15

FROM alpine:${ALPINE_VERSION}
ARG BUILD_DATE
ARG VCS_REF
ARG YOUTUBE_DL_OVERWRITE=
LABEL \
    org.opencontainers.image.authors="quentin.mcgaw@gmail.com" \
    org.opencontainers.image.created=$BUILD_DATE \
    org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.version="${YOUTUBE_DL_OVERWRITE}" \
    org.opencontainers.image.url="https://github.com/qdm12/youtube-dl-docker" \
    org.opencontainers.image.documentation="https://github.com/qdm12/youtube-dl-docker/blob/master/README.md" \
    org.opencontainers.image.source="https://github.com/qdm12/youtube-dl-docker" \
    org.opencontainers.image.title="youtube-dl-docker" \
    org.opencontainers.image.description="Download with youtube-dl using command line arguments or configuration files"
HEALTHCHECK --interval=10m --timeout=10s --retries=1 CMD [ "$(wget -qO- https://duckduckgo.com 2>/dev/null)" != "" ] || exit 1
ENV AUTOUPDATE=no \
    GOTIFYURL= \
    GOTIFYTOKEN=
ENTRYPOINT ["/entrypoint.sh"]
CMD ["-h"]
COPY entrypoint.sh /
RUN apk add -q --progress --update --no-cache ca-certificates ffmpeg python3 && \
    rm -rf /var/cache/apk/*
RUN apk add -q --progress --update --no-cache --virtual deps gnupg && \
    ln -s /usr/bin/python3 /usr/local/bin/python && \
    LATEST=${YOUTUBE_DL_OVERWRITE:-latest} && \
    wget -q https://yt-dl.org/downloads/$LATEST/youtube-dl -O /usr/local/bin/youtube-dl && \
    wget -q https://yt-dl.org/downloads/$LATEST/youtube-dl.sig -O /tmp/youtube-dl.sig && \
    gpg --keyserver keyserver.ubuntu.com --recv-keys 'ED7F5BF46B3BBED81C87368E2C393E0F18A9236D' && \
    gpg --verify /tmp/youtube-dl.sig /usr/local/bin/youtube-dl && \
    SHA256=$(wget -qO- https://yt-dl.org/downloads/$LATEST/SHA2-256SUMS | head -n 1 | cut -d " " -f 1) && \
    [ $(sha256sum /usr/local/bin/youtube-dl | cut -d " " -f 1) = "$SHA256" ] && \
    apk del deps && \
    rm -rf /var/cache/apk/* /tmp/youtube-dl.sig && \
    chown 1000 /entrypoint.sh /usr/local/bin/youtube-dl && \
    chmod 555 /entrypoint.sh && \
    chmod 777 /usr/local/bin/youtube-dl
USER 1000
