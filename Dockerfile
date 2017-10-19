ARG TEST="ubuntu:12.04"

FROM ${TEST}
LABEL maintainer="Telegram Desktop (https://github.com/telegramdesktop/docker)"
LABEL description="Build container for Telegram Desktop (Linux)"

ENV DEBIAN_FRONTEND=noninteractive
COPY tdesktop/Telegram/Patches /TBuild/tdesktop/Telegram/Patches
WORKDIR /TBuild/Libraries

ARG STAGE="all"

RUN echo ${STAGE}
