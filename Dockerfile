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
RUN ln -s /usr/bin/python3 /usr/local/bin/python && \
    LATEST=${YOUTUBE_DL_OVERWRITE:-latest} && \
    wget "https://github.com/yt-dlp/yt-dlp/releases/$LATEST/download/yt-dlp" -O /usr/local/bin/youtube-dl && \
    chown 1000 /entrypoint.sh /usr/local/bin/youtube-dl && \
    chmod 555 /entrypoint.sh && \
    chmod 777 /usr/local/bin/youtube-dl
USER 1000
