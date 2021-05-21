ARG ALPINE_IMAGE=alpine:3.12

FROM $ALPINE_IMAGE as builder
ARG FFMPEG_VERSION=4.4
ARG DOWNLOAD_URL=http://ffmpeg.org/releases/ffmpeg-4.4.tar.gz 

RUN apk add --update \
    build-base \
    coreutils \
    freetype-dev \
    gcc \
    lame-dev \
    openssl \
    openssl-dev \
    pkgconf \
    pkgconfig \
    rtmpdump-dev \
    wget \
    x264-dev \
    yasm \
    tzdata 

# Get fdk-aac from community.
ENV TZ Asia/Shanghai 
RUN echo "http://mirrors.ustc.edu.cn/alpine/edge/community" >> /etc/apk/repositories && \
    apk add --update fdk-aac-dev libsrt-dev && \
    export MAKEFLAGS="-j16" && \
    mkdir /tmp/ffmpeg_build && cd /tmp/ffmpeg_build && \
    echo "wget -q ${DOWNLOAD_URL}" && wget -q ${DOWNLOAD_URL} && \
    tar zx --strip-components=1 -f ffmpeg-${FFMPEG_VERSION}.tar.gz && \
    rm ffmpeg-${FFMPEG_VERSION}.tar.gz && \
    ./configure \
         --disable-avdevice \
         --enable-libmp3lame --enable-librtmp --enable-libfdk-aac --enable-libx264 \
         --enable-libsrt \
         --disable-doc --disable-programs --enable-ffmpeg --enable-ffprobe \
         --enable-static --disable-shared \
         --enable-gpl --enable-version3 --enable-nonfree \
         --extra-version=ThinkZ-$(date "+%Y%m%d-%H%M%S") && \
    make


FROM $ALPINE_IMAGE
COPY root /
COPY --from=builder /tmp/ffmpeg_build/ffmpeg /usr/local/bin/ffmpeg
COPY --from=builder /tmp/ffmpeg_build/ffprobe /usr/local/bin/ffprobe

RUN apk add --update --no-cache ca-certificates openssl lame librtmp x264-libs tzdata && \
    echo http://mirrors.ustc.edu.cn/alpine/edge/community >> /etc/apk/repositories && \
    apk add --update --no-cache libsrt fdk-aac && \
    chmod +x /usr/local/bin/docker-entrypoint.sh && \
    ffmpeg -buildconf

ENV TZ Asia/Shanghai 
ENTRYPOINT ["docker-entrypoint.sh"]

WORKDIR /tmp 

