FROM alpine
COPY script.sh ./
RUN apk add --update --no-cache ffmpeg curl bash python && \
    curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl && \
    chmod a+rx /usr/local/bin/youtube-dl && \
    chmod +x /script.sh && \
    mkdir /downloads
ENTRYPOINT ["/script.sh"]
CMD [""]