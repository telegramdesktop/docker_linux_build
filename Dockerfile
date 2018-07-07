ARG FROM="ubuntu:14.04"

FROM ${FROM}

LABEL maintainer="Telegram Desktop (https://github.com/telegramdesktop/docker_linux_build)"
LABEL description="Build container for Telegram Desktop (Linux)"

ENV DEBIAN_FRONTEND=noninteractive
ENV TDESKTOP_BRANCH=master
ENV VERSION=Release
ENV MAKE_THREADS_CNT=-j8

ARG STAGE="all"

COPY tdesktop/Telegram/Patches /TBuild/tdesktop/Telegram/Patches
COPY build_tdesktop.sh /TBuild/build_tdesktop.sh

WORKDIR /TBuild/Libraries

# dependencies from PPA repositories
RUN if [ "$STAGE" = "dependencies1" ] || [ "${STAGE}" = "all" ]; then \
    apt-get update && \
    apt-get install -qy software-properties-common && \
    add-apt-repository -y ppa:ubuntu-toolchain-r/test && \
    add-apt-repository -y ppa:george-edison55/cmake-3.x && \
    apt-get update && \
    apt-get install -qy gcc-7 g++-7 cmake && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 60 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 60 && \
    add-apt-repository -y --remove ppa:ubuntu-toolchain-r/test && \
    add-apt-repository -y --remove ppa:george-edison55/cmake-3.x
    fi

# dependencies from Ubuntu repositories
RUN if [ "$STAGE" = "dependencies1" ] || [ "${STAGE}" = "all" ]; then \
    apt-get update && \
    apt-get install -qy \
    autoconf \
    automake \
    bison \
    dh-autoreconf \
    git \
    libappindicator-dev \
    libasound-dev \
    libass-dev \
    libdee-dev \
    libdrm-dev \
    libexif-dev \
    libffi-dev \
    libfreetype6-dev \
    libgpac-dev \
    libicu-dev \
    liblzma-dev \
    libncurses5-dev \
    libpulse-dev \
    libsdl1.2-dev \
    libssl-dev \
    libtheora-dev \
    libtool \
    libunity-dev \
    libva-dev \
    libvdpau-dev \
    libvorbis-dev \
    libx11-xcb-dev \
    libxcb-icccm4-dev \
    libxcb-image0-dev \
    libxcb-keysyms1-dev \
    libxcb-randr0-dev \
    libxcb-render-util0-dev \
    libxcb-shm0-dev \
    libxcb-sync0-dev \
    libxcb-util0-dev \
    libxcb-xfixes0-dev \
    libxcb1-dev \
    libxrender-dev \
    libz-dev \
    pkg-config \
    python-xcbgen \
    texi2html \
    xutils-dev \
    yasm cmake \
    zlib1g-dev
    fi

# range
RUN if [ "$STAGE" = "dependencies1" ] || [ "${STAGE}" = "all" ]; then \
    git clone https://github.com/ericniebler/range-v3
    fi

# zlib
RUN if [ "$STAGE" = "dependencies1" ] || [ "${STAGE}" = "all" ]; then \
    git clone https://github.com/telegramdesktop/zlib.git && \
    cd zlib && \
    ./configure && \
    make $MAKE_THREADS_CNT && \
    make install
    fi

# opus
RUN if [ "$STAGE" = "dependencies1" ] || [ "${STAGE}" = "all" ]; then \
    git clone https://github.com/xiph/opus && \
    cd opus && \
    git checkout v1.2.1 && \
    ./autogen.sh && \
    ./configure && \
    make $MAKE_THREADS_CNT && \
    make install
    fi

# libva
RUN if [ "$STAGE" = "dependencies1" ] || [ "${STAGE}" = "all" ]; then \
    git clone https://github.com/01org/libva.git && \
    cd libva && \
    ./autogen.sh --enable-static && \
    make $MAKE_THREADS_CNT && \
    make install
    fi

# libvdpau
RUN if [ "$STAGE" = "dependencies1" ] || [ "${STAGE}" = "all" ]; then \
    git clone git://anongit.freedesktop.org/vdpau/libvdpau && \
    cd libvdpau && \
    ./autogen.sh --enable-static && \
    make $MAKE_THREADS_CNT && \
    make install
    fi

# ffmpeg
RUN if [ "$STAGE" = "dependencies1" ] || [ "${STAGE}" = "all" ]; then \
    git clone https://github.com/FFmpeg/FFmpeg.git ffmpeg && \
    cd ffmpeg && \
    git checkout release/3.4 && \
    ./configure \
    --disable-doc \
    --disable-everything \
    --disable-programs \
    --enable-decoder=aac \
    --enable-decoder=aac_latm \
    --enable-decoder=aasc \
    --enable-decoder=flac \
    --enable-decoder=gif \
    --enable-decoder=h264 \
    --enable-decoder=h264_vdpau \
    --enable-decoder=mp1 \
    --enable-decoder=mp1float \
    --enable-decoder=mp2 \
    --enable-decoder=mp2float \
    --enable-decoder=mp3 \
    --enable-decoder=mp3adu \
    --enable-decoder=mp3adufloat \
    --enable-decoder=mp3float \
    --enable-decoder=mp3on4 \
    --enable-decoder=mp3on4float \
    --enable-decoder=mpeg4 \
    --enable-decoder=mpeg4_vdpau \
    --enable-decoder=msmpeg4v2 \
    --enable-decoder=msmpeg4v3 \
    --enable-decoder=opus \
    --enable-decoder=pcm_alaw \
    --enable-decoder=pcm_alaw_at \
    --enable-decoder=pcm_f32be \
    --enable-decoder=pcm_f32le \
    --enable-decoder=pcm_f64be \
    --enable-decoder=pcm_f64le \
    --enable-decoder=pcm_lxf \
    --enable-decoder=pcm_mulaw \
    --enable-decoder=pcm_mulaw_at \
    --enable-decoder=pcm_s16be \
    --enable-decoder=pcm_s16be_planar \
    --enable-decoder=pcm_s16le \
    --enable-decoder=pcm_s16le_planar \
    --enable-decoder=pcm_s24be \
    --enable-decoder=pcm_s24daud \
    --enable-decoder=pcm_s24le \
    --enable-decoder=pcm_s24le_planar \
    --enable-decoder=pcm_s32be \
    --enable-decoder=pcm_s32le \
    --enable-decoder=pcm_s32le_planar \
    --enable-decoder=pcm_s64be \
    --enable-decoder=pcm_s64le \
    --enable-decoder=pcm_s8 \
    --enable-decoder=pcm_s8_planar \
    --enable-decoder=pcm_u16be \
    --enable-decoder=pcm_u16le \
    --enable-decoder=pcm_u24be \
    --enable-decoder=pcm_u24le \
    --enable-decoder=pcm_u32be \
    --enable-decoder=pcm_u32le \
    --enable-decoder=pcm_u8 \
    --enable-decoder=pcm_zork \
    --enable-decoder=vorbis \
    --enable-decoder=wavpack \
    --enable-decoder=wmalossless \
    --enable-decoder=wmapro \
    --enable-decoder=wmav1 \
    --enable-decoder=wmav2 \
    --enable-decoder=wmavoice \
    --enable-demuxer=aac \
    --enable-demuxer=flac \
    --enable-demuxer=gif \
    --enable-demuxer=h264 \
    --enable-demuxer=mov \
    --enable-demuxer=mp3 \
    --enable-demuxer=ogg \
    --enable-demuxer=wav \
    --enable-encoder=libopus \
    --enable-hwaccel=h264_vaapi \
    --enable-hwaccel=h264_vdpau \
    --enable-hwaccel=mpeg4_vaapi \
    --enable-hwaccel=mpeg4_vdpau \
    --enable-libopus \
    --enable-muxer=ogg \
    --enable-muxer=opus \
    --enable-parser=aac \
    --enable-parser=aac_latm \
    --enable-parser=flac \
    --enable-parser=h264 \
    --enable-parser=mpeg4video \
    --enable-parser=mpegaudio \
    --enable-parser=opus \
    --enable-parser=vorbis \
    --enable-protocol=file \
    --prefix=/usr/local \
    && \
    make $MAKE_THREADS_CNT && \
    make install
    fi

# portaudio
RUN if [ "$STAGE" = "dependencies1" ] || [ "${STAGE}" = "all" ]; then \
    git clone https://git.assembla.com/portaudio.git && \
    cd portaudio && \
    git checkout 396fe4b669 && \
    ./configure && \
    make $MAKE_THREADS_CNT && \
    make install
    fi

# openal-soft
RUN if [ "$STAGE" = "dependencies1" ] || [ "${STAGE}" = "all" ]; then \
    git clone git://repo.or.cz/openal-soft.git && \
    cd openal-soft && \
    git checkout v1.18 && \
    cd build && \
    cmake -D LIBTYPE:STRING=STATIC .. && \
    make $MAKE_THREADS_CNT && \
    make install
    fi

# openssl
RUN if [ "$STAGE" = "dependencies1" ] || [ "${STAGE}" = "all" ]; then \
    git clone https://github.com/openssl/openssl && \
    cd openssl && \
    git checkout OpenSSL_1_0_1-stable && \
    ./config && \
    make $MAKE_THREADS_CNT && \
    make install
    fi

# libxkbcommon
RUN if [ "$STAGE" = "dependencies1" ] || [ "${STAGE}" = "all" ]; then \
    git clone https://github.com/xkbcommon/libxkbcommon.git && \
    cd libxkbcommon && \
    ./autogen.sh --disable-x11 && \
    make $MAKE_THREADS_CNT && \
    make install
    fi

# qt
RUN if [ "$STAGE" = "dependencies2" ] || [ "${STAGE}" = "all" ]; then \
    git clone git://code.qt.io/qt/qt5.git qt5_6_2 && \
    cd qt5_6_2 && \
    perl init-repository --module-subset=qtbase,qtimageformats && \
    git checkout v5.6.2 && \
    cd qtimageformats && git checkout v5.6.2 && cd .. && \
    cd qtbase && git checkout v5.6.2 && cd .. && \
    cd qtbase && git apply ../../../tdesktop/Telegram/Patches/qtbase_5_6_2.diff && cd .. && \
    cd qtbase/src/plugins/platforminputcontexts && \
    git clone https://github.com/telegramdesktop/fcitx.git && \
    git clone https://github.com/telegramdesktop/hime.git && \
    cd ../../../.. && \
    ./configure -prefix "/usr/local/tdesktop/Qt-5.6.2" \
    -confirm-license \
    -force-debug-info \
    -no-gtkstyle \
    -no-opengl \
    -nomake examples \
    -nomake tests \
    -opensource \
    -openssl-linked \
    -qt-freetype \
    -qt-harfbuzz \
    -qt-libjpeg \
    -qt-libpng \
    -qt-pcre \
    -qt-xcb \
    -qt-xkbcommon-x11 \
    -qt-zlib \
    -release \
    -static \
    && \
    make $MAKE_THREADS_CNT && \
    make install
    fi

# gyp
RUN if [ "$STAGE" = "dependencies2" ] || [ "${STAGE}" = "all" ]; then \
    git clone https://chromium.googlesource.com/external/gyp && \
    cd gyp && \
    git checkout 702ac58e47 && \
    git apply ../../tdesktop/Telegram/Patches/gyp.diff
    fi

# breakpad
RUN if [ "$STAGE" = "dependencies2" ] || [ "${STAGE}" = "all" ]; then \
    git clone https://chromium.googlesource.com/breakpad/breakpad && \
    cd breakpad && \
    git checkout bc8fb886 && \
    git clone https://chromium.googlesource.com/linux-syscall-support src/third_party/lss && \
    cd src/third_party/lss && \
    git checkout a91633d1 && \
    cd ../../.. && \
    ./configure && \
    make $MAKE_THREADS_CNT && \
    make install && \
    cd src/tools && \
    ../../../gyp/gyp  --depth=. --generator-output=.. -Goutput_dir=../out tools.gyp --format=cmake && \
    cd ../../out/Default && \
    cmake . && \
    make $MAKE_THREADS_CNT dump_syms; exit 0
    fi

WORKDIR /TBuild

# remove patches
RUN if [ "$STAGE" = "dependencies2" ] || [ "${STAGE}" = "all" ]; then \
    rm -rf tdesktop
    fi

# build Telegram Desktop on every container run
CMD ./build_tdesktop.sh

