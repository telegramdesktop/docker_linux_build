#!/bin/bash

TDESKTOP_BRANCH="master"
VERSION="Release"
MAKE_THREADS_CNT="-j8"

CONTAINER_NAME="tdesktop-linux"
IMAGE_NAME="telegramdesktop/linux_build"

while test $# -gt 0; do
  case "$1" in
    -b)
      shift
      if test $# -gt 0; then
        TDESKTOP_BRANCH="$1"
      else
        echo "Invalid argument."
        echo "Correct: -b <branch_name>"
        exit 1
      fi
      shift
      ;;

    -v)
      shift
      if test $# -gt 0; then
        VERSION="$1"
      else
        echo "Invalid argument."
        echo "Correct: -v <build_version [Release|Debug]>"
        exit 1
      fi
      shift
      ;;

    -m)
      shift
      if test $# -gt 0; then
        MAKE_THREADS_CNT="$1"
      else
        echo "Invalid argument."
        echo "Correct: -m <make_flag>"
        exit 1
      fi
      shift
      ;;

    *)
      echo "Invalid flag."
      echo "Options: [-b <branch_name>] [-v <build_version>] [-m <make_flag>]"
      exit 1
      ;;

  esac
done

#docker run --name $CONTAINER_NAME --env TDESKTOP_BRANCH=${TDESKTOP_BRANCH} --env VERSION=${VERSION} --env MAKE_THREADS_CNT=${MAKE_THREADS_CNT} $IMAGE_NAME 

BIN_PATH="/TBuild/tdesktop/out/${VERSION}/Telegram"
DEST_PATH="bin"

mkdir -p $DEST_PATH || exit 1

# copy the builded binary from container to host on DEST_PATH
docker cp ${CONTAINER_NAME}:${BIN_PATH} $DEST_PATH
