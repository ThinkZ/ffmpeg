FROM scratch
ADD alpine-minirootfs-3.13.1-x86_64.tar.gz /

RUN apk add --update ca-certificates \
            openssl \
            lame \
            librtmp 

CMD ["/bin/ash"]
