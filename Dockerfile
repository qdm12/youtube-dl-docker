ARG BASE_IMAGE=alpine
ARG ALPINE_VERSION=3.10

FROM ${BASE_IMAGE}:${ALPINE_VERSION}
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
    org.opencontainers.image.description="Download with youtube-dl using command line arguments or configuration files" \
    image-size="97.7MB" \
    ram-usage="Variable" \
    cpu-usage="Variable"
HEALTHCHECK --interval=10m --timeout=10s --retries=1 CMD [ "$(wget -qO- https://duckduckgo.com 2>/dev/null)" != "" ] || exit 1
ENV LOG=yes \
    AUTOUPDATE=no \
    GOTIFYURL= \
    GOTIFYTOKEN=
ENTRYPOINT ["/entrypoint.sh"]
CMD ["-h"]
COPY entrypoint.sh /
RUN apk add -q --progress --update --no-cache ca-certificates wget ffmpeg python gnupg curl && \
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
