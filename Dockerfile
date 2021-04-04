FROM scratch
ADD alpine-minirootfs-3.13.1-x86_64.tar.gz /

RUN apk add --no-cache ca-certificates openssl lame librtmp

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

# CMD ["ffmpeg"]

