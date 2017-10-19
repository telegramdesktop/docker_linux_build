ARG FROM="ubuntu:12.04"

FROM ${FROM}
LABEL maintainer="Telegram Desktop (https://github.com/telegramdesktop/docker)"
LABEL description="Build container for Telegram Desktop (Linux)"

ENV DEBIAN_FRONTEND=noninteractive
COPY tdesktop/Telegram/Patches /TBuild/tdesktop/Telegram/Patches
WORKDIR /TBuild/Libraries

ARG STAGE="all"

# Tools
RUN if [ "$STAGE" = "dependencies1" ] || [ "${STAGE}" = "all" ]; then \
    apt-get update -q && \
    apt-get install -qy git wget dos2unix software-properties-common python-software-properties; \
    fi

# Dev Libraries
RUN if [ "${STAGE}" = "dependencies1" ] || [ "${STAGE}" = "all" ]; then \
    apt-get install -qy libexif-dev liblzma-dev libz-dev libssl-dev libappindicator-dev libunity-dev libicu-dev libdee-dev && \
    apt-get -qy --force-yes install gettext libtool autoconf automake build-essential libass-dev libfreetype6-dev libgpac-dev libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev pkg-config texi2html zlib1g-dev && \
    apt-get install -qy yasm && \
    apt-get install -qy xutils-dev bison python-xcbgen && \
    apt-get install -qy libxcb1-dev libxcb-image0-dev libxcb-keysyms1-dev libxcb-icccm4-dev libxcb-render-util0-dev libxcb-util0-dev libxrender-dev libasound-dev libpulse-dev libxcb-sync0-dev libxcb-xfixes0-dev libxcb-randr0-dev libx11-xcb-dev libffi-dev; \
    fi

# Gcc
RUN if [ "${STAGE}" = "dependencies1" ] || [ "${STAGE}" = "all" ]; then \
    add-apt-repository -y ppa:ubuntu-toolchain-r/test && \
    apt-get update -q && \
    apt-get install -qy gcc-6 g++-6 && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 60 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-6 60; \
    fi

# Cmake
RUN if [ "${STAGE}" = "dependencies1" ] || [ "${STAGE}" = "all" ]; then \
    wget -qnv https://cmake.org/files/v3.6/cmake-3.6.2.tar.gz && \
    tar -xf cmake-3.6.2.tar.gz && cd cmake-3.6.2 && \
    ./configure && make ${MAKE_ARGS} && make install; \
    fi

# Zlib
RUN if [ "${STAGE}" = "dependencies1" ] || [ "${STAGE}" = "all" ]; then \
    git clone https://github.com/telegramdesktop/zlib.git && \
    cd zlib  && \
    ./configure && make ${MAKE_ARGS} && make install; \
    fi

# Opus
RUN if [ "${STAGE}" = "dependencies1" ] || [ "${STAGE}" = "all" ]; then \
    git clone https://github.com/xiph/opus.git && \
    cd opus && git checkout v1.2-alpha2 && \
    ./autogen.sh && ./configure && make && make install; \
    fi

# LibVA
RUN if [ "${STAGE}" = "dependencies1" ] || [ "${STAGE}" = "all" ]; then \
    git clone https://github.com/01org/libva.git && \
    cd libva && ./autogen.sh --enable-static && \
    make ${MAKE_ARGS} &&  make install; \
    fi

# LibVdpau
RUN if [ "${STAGE}" = "dependencies1" ] || [ "${STAGE}" = "all" ]; then \
    git clone git://anongit.freedesktop.org/vdpau/libvdpau && \
    cd libvdpau && \
    ./autogen.sh --enable-static && \
    make ${MAKE_ARGS} &&  make install; \
    fi

# FFmpeg
RUN if [ "${STAGE}" = "dependencies1" ] || [ "${STAGE}" = "all" ]; then \
    git clone https://github.com/FFmpeg/FFmpeg.git ffmpeg && \
    cd ffmpeg && git checkout -q release/3.2 && \
    ./configure --prefix=/usr/local --disable-programs --disable-doc --disable-everything --enable-protocol=file --enable-libopus --enable-decoder=aac --enable-decoder=aac_latm --enable-decoder=aasc --enable-decoder=flac --enable-decoder=gif --enable-decoder=h264 --enable-decoder=h264_vdpau --enable-decoder=mp1 --enable-decoder=mp1float --enable-decoder=mp2 --enable-decoder=mp2float --enable-decoder=mp3 --enable-decoder=mp3adu --enable-decoder=mp3adufloat --enable-decoder=mp3float --enable-decoder=mp3on4 --enable-decoder=mp3on4float --enable-decoder=mpeg4 --enable-decoder=mpeg4_vdpau --enable-decoder=msmpeg4v2 --enable-decoder=msmpeg4v3 --enable-decoder=opus --enable-decoder=pcm_alaw --enable-decoder=pcm_alaw_at --enable-decoder=pcm_f32be --enable-decoder=pcm_f32le --enable-decoder=pcm_f64be --enable-decoder=pcm_f64le --enable-decoder=pcm_lxf --enable-decoder=pcm_mulaw --enable-decoder=pcm_mulaw_at --enable-decoder=pcm_s16be --enable-decoder=pcm_s16be_planar --enable-decoder=pcm_s16le --enable-decoder=pcm_s16le_planar --enable-decoder=pcm_s24be --enable-decoder=pcm_s24daud --enable-decoder=pcm_s24le --enable-decoder=pcm_s24le_planar --enable-decoder=pcm_s32be --enable-decoder=pcm_s32le --enable-decoder=pcm_s32le_planar --enable-decoder=pcm_s64be --enable-decoder=pcm_s64le --enable-decoder=pcm_s8 --enable-decoder=pcm_s8_planar --enable-decoder=pcm_u16be --enable-decoder=pcm_u16le --enable-decoder=pcm_u24be --enable-decoder=pcm_u24le --enable-decoder=pcm_u32be --enable-decoder=pcm_u32le --enable-decoder=pcm_u8 --enable-decoder=pcm_zork --enable-decoder=vorbis --enable-decoder=wavpack --enable-decoder=wmalossless --enable-decoder=wmapro --enable-decoder=wmav1 --enable-decoder=wmav2 --enable-decoder=wmavoice --enable-encoder=libopus --enable-hwaccel=h264_vaapi --enable-hwaccel=h264_vdpau --enable-hwaccel=mpeg4_vaapi --enable-hwaccel=mpeg4_vdpau --enable-parser=aac --enable-parser=aac_latm --enable-parser=flac --enable-parser=h264 --enable-parser=mpeg4video --enable-parser=mpegaudio --enable-parser=opus --enable-parser=vorbis --enable-demuxer=aac --enable-demuxer=flac --enable-demuxer=gif --enable-demuxer=h264 --enable-demuxer=mov --enable-demuxer=mp3 --enable-demuxer=ogg --enable-demuxer=wav --enable-muxer=ogg --enable-muxer=opus && \
    make ${MAKE_ARGS} &&  make install; \
    fi

# PortAudio
RUN if [ "${STAGE}" = "dependencies1" ] || [ "${STAGE}" = "all" ]; then \
    git clone https://git.assembla.com/portaudio.git && \
    cd portaudio && git checkout tags/pa_stable_v19_20140130_r1919 && \
    ./configure && make ${MAKE_ARGS} && make install; \
    fi

# OpenAL
RUN if [ "${STAGE}" = "dependencies1" ] || [ "${STAGE}" = "all" ]; then \
    git clone git://repo.or.cz/openal-soft.git && \
    cd openal-soft/build && \
    cmake -D LIBTYPE:STRING=STATIC .. && \
    make ${MAKE_ARGS} && make install; \
    fi

# OpenSSL
RUN if [ "${STAGE}" = "dependencies2" ] || [ "${STAGE}" = "all" ]; then \
    git clone https://github.com/openssl/openssl && \
    cd openssl && git checkout -q OpenSSL_1_0_1-stable && \
    ./config && make ${MAKE_ARGS} && make install; \
    fi

# Libxcbcommon
RUN if [ "${STAGE}" = "dependencies2" ] || [ "${STAGE}" = "all" ]; then \
    git clone https://github.com/xkbcommon/libxkbcommon.git && \
    cd libxkbcommon && \
    ./autogen.sh --disable-x11 && \
    make ${MAKE_ARGS} && make install; \
    fi

# Patching QT5
RUN if [ "${STAGE}" = "dependencies2" ] || [ "${STAGE}" = "all" ]; then \
    git clone git://code.qt.io/qt/qt5.git qt5_6_2 && \
    cd qt5_6_2 && \
    perl init-repository --module-subset=qtbase,qtimageformats && \
    git checkout -q v5.6.2 && \
    cd qtimageformats && git checkout -q v5.6.2 && cd .. && \
    cd qtbase && git checkout -q v5.6.2 && \
    git apply ../../../tdesktop/Telegram/Patches/qtbase_5_6_2.diff && \
    cd src/plugins/platforminputcontexts && \
    git clone https://github.com/telegramdesktop/fcitx.git && \
    git clone https://github.com/telegramdesktop/hime.git && \
    cd ../../../.. && \
    ./configure -prefix "/usr/local/tdesktop/Qt-5.6.2" -release -force-debug-info -opensource -confirm-license -qt-zlib -qt-libpng -qt-libjpeg -qt-freetype -qt-harfbuzz -qt-pcre -qt-xcb -qt-xkbcommon-x11 -no-opengl -no-gtkstyle -static -openssl-linked -nomake examples -nomake tests && \
    make ${MAKE_ARGS} && make install; \
    fi

# Breakpad
RUN if [ "${STAGE}" = "dependencies2" ] || [ "${STAGE}" = "all" ]; then \
    git clone https://chromium.googlesource.com/breakpad/breakpad && \
    git clone https://chromium.googlesource.com/linux-syscall-support breakpad/src/third_party/lss && \
    cd breakpad && ./configure --prefix=$PWD && \
    make ${MAKE_ARGS} && make install; \
    fi

# Gyp
RUN if [ "${STAGE}" = "dependencies2" ] || [ "${STAGE}" = "all" ]; then \
    git clone https://chromium.googlesource.com/external/gyp && \
    cd gyp && git checkout -q 702ac58e47 && \
    git apply ../../tdesktop/Telegram/Patches/gyp.diff && \
    fi
