FROM alpine
RUN apk update && apk add --no-cache ffmpeg curl bash python
RUN curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl && chmod a+rx /usr/local/bin/youtube-dl
COPY script.sh ./
RUN chmod +x /script.sh && mkdir /downloads
VOLUME /downloads
ENTRYPOINT ["/script.sh"]
CMD [""]
