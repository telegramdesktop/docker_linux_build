#!/bin/bash

BUILD_DIR="/TBuild"
SOURCE_DIR="$BUILD_DIR/tdesktop"

if [ ! -d $SOURCE_DIR ]; then
    cd $BUILD_DIR || exit 1
    git clone -b $TDESKTOP_BRANCH --recursive https://github.com/telegramdesktop/tdesktop.git $SOURCE_DIR
fi

cd $SOURCE_DIR/Telegram || exit 1
gyp/refresh.sh

cd $SOURCE_DIR/out/$VERSION || exit 1
make $MAKE_THREADS_CNT
