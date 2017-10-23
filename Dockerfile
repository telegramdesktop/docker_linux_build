ARG FROM="ubuntu:14.04"

FROM ${FROM}
LABEL maintainer="Telegram Desktop (https://github.com/telegramdesktop/docker_linux_build)"
LABEL description="Build container for Telegram Desktop (Linux)"

ENV DEBIAN_FRONTEND=noninteractive
COPY tdesktop/Telegram/Patches /TBuild/tdesktop/Telegram/Patches
ADD build_tdesktop.sh /TBuild/build_tdesktop.sh
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

RUN if [ "$STAGE" = "dependencies1" ] || [ "${STAGE}" = "all" ]; then \
    apt-get install -qy git libexif-dev liblzma-dev libz-dev libssl-dev libappindicator-dev libunity-dev libicu-dev libdee-dev libdrm-dev dh-autoreconf autoconf automake libass-dev libfreetype6-dev libgpac-dev libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-image0-dev libxcb-shm0-dev libxcb-xfixes0-dev libxcb-keysyms1-dev libxcb-icccm4-dev libxcb-render-util0-dev libxcb-util0-dev libxrender-dev libasound-dev libpulse-dev libxcb-sync0-dev libxcb-randr0-dev libx11-xcb-dev libffi-dev libncurses5-dev pkg-config texi2html zlib1g-dev yasm cmake xutils-dev bison python-xcbgen; \
    fi

# zlib
RUN if [ "$STAGE" = "dependencies1" ] || [ "${STAGE}" = "all" ]; then \
    git clone https://github.com/telegramdesktop/zlib.git && \
    cd zlib && \
    ./configure && make $MAKE_ARGS && make install && \
	cd .. && rm -rf zlib; \
    fi

# opus
RUN if [ "$STAGE" = "dependencies1" ] || [ "${STAGE}" = "all" ]; then \
    git clone https://github.com/xiph/opus && \
    cd opus && git checkout v1.2-alpha2 && \
    ./autogen.sh && ./configure && make $MAKE_ARGS && make install && \
	cd .. && rm -rf opus; \
    fi

# libva
RUN if [ "$STAGE" = "dependencies1" ] || [ "${STAGE}" = "all" ]; then \
    git clone https://github.com/01org/libva.git && \
    cd libva && \
    ./autogen.sh --enable-static && \
    make $MAKE_ARGS && make install && \
	cd .. && rm -rf libva; \
	fi

# libvdpau
RUN if [ "$STAGE" = "dependencies1" ] || [ "${STAGE}" = "all" ]; then \
    git clone git://anongit.freedesktop.org/vdpau/libvdpau && \
    cd libvdpau && \
    ./autogen.sh --enable-static && \
    make $MAKE_ARGS && make install && \
	cd .. && rm -rf libvdpau; \
	fi

# ffmpeg
RUN if [ "$STAGE" = "dependencies1" ] || [ "${STAGE}" = "all" ]; then \
    git clone https://github.com/FFmpeg/FFmpeg.git ffmpeg && \
    cd ffmpeg && \
    git checkout release/3.2 && \
    ./configure --prefix=/usr/local --disable-programs --disable-doc --disable-everything --enable-protocol=file --enable-libopus --enable-decoder=aac --enable-decoder=aac_latm --enable-decoder=aasc --enable-decoder=flac --enable-decoder=gif --enable-decoder=h264 --enable-decoder=h264_vdpau --enable-decoder=mp1 --enable-decoder=mp1float --enable-decoder=mp2 --enable-decoder=mp2float --enable-decoder=mp3 --enable-decoder=mp3adu --enable-decoder=mp3adufloat --enable-decoder=mp3float --enable-decoder=mp3on4 --enable-decoder=mp3on4float --enable-decoder=mpeg4 --enable-decoder=mpeg4_vdpau --enable-decoder=msmpeg4v2 --enable-decoder=msmpeg4v3 --enable-decoder=opus --enable-decoder=pcm_alaw --enable-decoder=pcm_alaw_at --enable-decoder=pcm_f32be --enable-decoder=pcm_f32le --enable-decoder=pcm_f64be --enable-decoder=pcm_f64le --enable-decoder=pcm_lxf --enable-decoder=pcm_mulaw --enable-decoder=pcm_mulaw_at --enable-decoder=pcm_s16be --enable-decoder=pcm_s16be_planar --enable-decoder=pcm_s16le --enable-decoder=pcm_s16le_planar --enable-decoder=pcm_s24be --enable-decoder=pcm_s24daud --enable-decoder=pcm_s24le --enable-decoder=pcm_s24le_planar --enable-decoder=pcm_s32be --enable-decoder=pcm_s32le --enable-decoder=pcm_s32le_planar --enable-decoder=pcm_s64be --enable-decoder=pcm_s64le --enable-decoder=pcm_s8 --enable-decoder=pcm_s8_planar --enable-decoder=pcm_u16be --enable-decoder=pcm_u16le --enable-decoder=pcm_u24be --enable-decoder=pcm_u24le --enable-decoder=pcm_u32be --enable-decoder=pcm_u32le --enable-decoder=pcm_u8 --enable-decoder=pcm_zork --enable-decoder=vorbis --enable-decoder=wavpack --enable-decoder=wmalossless --enable-decoder=wmapro --enable-decoder=wmav1 --enable-decoder=wmav2 --enable-decoder=wmavoice --enable-encoder=libopus --enable-hwaccel=h264_vaapi --enable-hwaccel=h264_vdpau --enable-hwaccel=mpeg4_vaapi --enable-hwaccel=mpeg4_vdpau --enable-parser=aac --enable-parser=aac_latm --enable-parser=flac --enable-parser=h264 --enable-parser=mpeg4video --enable-parser=mpegaudio --enable-parser=opus --enable-parser=vorbis --enable-demuxer=aac --enable-demuxer=flac --enable-demuxer=gif --enable-demuxer=h264 --enable-demuxer=mov --enable-demuxer=mp3 --enable-demuxer=ogg --enable-demuxer=wav --enable-muxer=ogg --enable-muxer=opus && \
    make $MAKE_ARGS && make install && \
	cd .. && rm -rf ffmpeg; \
	fi

# portaudio
RUN if [ "$STAGE" = "dependencies1" ] || [ "${STAGE}" = "all" ]; then \
    git clone https://git.assembla.com/portaudio.git && \
    cd portaudio && git checkout 396fe4b669 && \
    ./configure && \
    make $MAKE_ARGS && make install && \
	cd .. && rm -rf portaudio; \
    fi

# openal-soft
RUN if [ "$STAGE" = "dependencies1" ] || [ "${STAGE}" = "all" ]; then \
    git clone git://repo.or.cz/openal-soft.git && \
    cd openal-soft/build && \
    cmake -D LIBTYPE:STRING=STATIC .. && \
    make $MAKE_ARGS && make install && \
	cd ../.. && rm -rf openal-soft; \
    fi

# openssl
RUN if [ "$STAGE" = "dependencies1" ] || [ "${STAGE}" = "all" ]; then \
    git clone https://github.com/openssl/openssl && \
    cd openssl && git checkout OpenSSL_1_0_1-stable && \
    ./config && make $MAKE_ARGS && make install && \
	cd .. && rm -rf openssl; \
    fi

# libxkbcommon
RUN if [ "$STAGE" = "dependencies1" ] || [ "${STAGE}" = "all" ]; then \
    git clone https://github.com/xkbcommon/libxkbcommon.git && \
    cd libxkbcommon && \
    ./autogen.sh --disable-x11 && \
    make $MAKE_ARGS && make install && \
	cd .. && rm -rf libxkbcommon; \
    fi

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
    ./configure -prefix "/usr/local/tdesktop/Qt-5.6.2" -release -force-debug-info -opensource -confirm-license -qt-zlib -qt-libpng -qt-libjpeg -qt-freetype -qt-harfbuzz -qt-pcre -qt-xcb -qt-xkbcommon-x11 -no-opengl -no-gtkstyle -static -openssl-linked -nomake examples -nomake tests && \
    make $MAKE_ARGS && make install && \
	cd .. && rm -rf qt5_6_2; \
	fi

# gyp
RUN if [ "$STAGE" = "dependencies2" ] || [ "${STAGE}" = "all" ]; then \
    git clone https://chromium.googlesource.com/external/gyp && \
    cd gyp && \
    git checkout 702ac58e47 && \
    git apply ../../tdesktop/Telegram/Patches/gyp.diff; \
    fi

# breakpad
RUN if [ "$STAGE" = "dependencies2" ] || [ "${STAGE}" = "all" ]; then \
    git clone https://chromium.googlesource.com/breakpad/breakpad && \
    git clone https://chromium.googlesource.com/linux-syscall-support breakpad/src/third_party/lss && \
    cd breakpad && \
    ./configure && make $MAKE_ARGS && make install && \
    cd .. && rm -rf breakpad; \
    fi

# delete patches
RUN if [ "$STAGE" = "dependencies2" ] || [ "${STAGE}" = "all" ]; then \
    rm -rf tdesktop; \
	fi

#CMD /TBuild/build_tdesktop.sh
