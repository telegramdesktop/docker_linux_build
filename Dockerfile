ARG FROM="ubuntu:14.04"

FROM ${FROM}
LABEL maintainer="Telegram Desktop (https://github.com/telegramdesktop/docker)"
LABEL description="Build container for Telegram Desktop (Linux)"

ENV DEBIAN_FRONTEND=noninteractive
COPY tdesktop/Telegram/Patches /TBuild/tdesktop/Telegram/Patches
WORKDIR /TBuild/Libraries

ARG STAGE="all"
ARG MAKE_ARGS="--silent -j4"

# Tools
RUN if [ "$STAGE" = "dependencies1" ] || [ "${STAGE}" = "all" ]; then \
    apt-get update && \
    apt-get install -qy software-properties-common && \
    add-apt-repository ppa:ubuntu-toolchain-r/test && \
    add-apt-repository ppa:george-edison55/cmake-3.x && \
    apt-get update && \
    apt-get install -qy gcc-7 g++-7 cmake && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 60 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 60 && \
    add-apt-repository --remove ppa:ubuntu-toolchain-r/test && \
    add-apt-repository --remove ppa:george-edison55/cmake-3.x; \
    fi

RUN g++ --version

RUN apt-get install gcc g++ build-essential

#RUN if [ "$STAGE" = "dependencies1" ] || [ "${STAGE}" = "all" ]; then \
#    apt-get install -qy git libexif-dev liblzma-dev libz-dev libssl-dev libappindicator-dev libunity-dev libicu-dev libdee-dev libdrm-dev dh-autoreconf autoconf automake build-essential libass-dev libfreetype6-dev libgpac-dev libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-image0-dev libxcb-shm0-dev libxcb-xfixes0-dev libxcb-keysyms1-dev libxcb-icccm4-dev libxcb-render-util0-dev libxcb-util0-dev libxrender-dev libasound-dev libpulse-dev libxcb-sync0-dev libxcb-randr0-dev libx11-xcb-dev libffi-dev libncurses5-dev pkg-config texi2html zlib1g-dev yasm cmake xutils-dev bison python-xcbgen; \
#    fi
