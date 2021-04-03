FROM scratch
ADD alpine-minirootfs-3.13.1-x86_64.tar.gz /
CMD ["/bin/ash"]
