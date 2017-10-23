BUILD_DIR="/TBuild"

cd %BUILD_DIR
git clone --recursive https://github.com/telegramdesktop/tdesktop.git

cd %BUILD_DIR/tdesktop/Telegram
./gyp/refresh.sh

cd %BUILD_DIR/tdesktop/out/Debug
make -j4
