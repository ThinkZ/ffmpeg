FROM scratch
ADD https://dl-cdn.alpinelinux.org/alpine/v3.13/releases/x86_64/alpine-minirootfs-3.13.1-x86_64.tar.gz /
CMD ["/bin/sh"]
