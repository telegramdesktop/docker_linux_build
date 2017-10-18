if [ ! -d tdesktop ]; then
    git clone -b dev https://github.com/telegramdesktop/tdesktop.git
fi

docker build . -t tdesktop
