ARG FROM="ubuntu:12.04"

FROM ${FROM}
LABEL maintainer="Telegram Desktop (https://github.com/telegramdesktop/docker)"
LABEL description="Build container for Telegram Desktop (Linux)"

ENV DEBIAN_FRONTEND=noninteractive
COPY tdesktop/Telegram/Patches /TBuild/tdesktop/Telegram/Patches
WORKDIR /TBuild/Libraries

ARG STAGE="all"

# Tools
RUN if [ "${STAGE}" = "dependencies1" ] or [ "${STAGE}" = "all" ] ; then
    apt-get update -q && \
    apt-get install -qy git wget dos2unix software-properties-common python-software-properties
    fi

# Dev Libraries
RUN if [ "$STAGE" = "dependencies1" ] or [ "$STAGE" = "all" ] ; then \
    apt-get install -qy libexif-dev liblzma-dev libz-dev libssl-dev libappindicator-dev libunity-dev libicu-dev libdee-dev && \
    apt-get -qy --force-yes install gettext libtool autoconf automake build-essential libass-dev libfreetype6-dev libgpac-dev libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev pkg-config texi2html zlib1g-dev && \
    apt-get install -qy yasm && \
    apt-get install -qy xutils-dev bison python-xcbgen && \
    apt-get install -qy libxcb1-dev libxcb-image0-dev libxcb-keysyms1-dev libxcb-icccm4-dev libxcb-render-util0-dev libxcb-util0-dev libxrender-dev libasound-dev libpulse-dev libxcb-sync0-dev libxcb-xfixes0-dev libxcb-randr0-dev libx11-xcb-dev libffi-dev \
    fi
