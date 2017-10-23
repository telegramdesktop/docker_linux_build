# Docker image to build the linux version of Telegram Desktop

This repo contains the docker image to build the linux version of Telegram Desktop with just a few commands!

## Usage

// TODO

If you wan't to build your own version of Telegram Desktop, mount the folder `/TBuild/tdesktop` to your host and place your source into the folder.

## Available environment variables

| Name            | Description                                                                                                   |
|-----------------|---------------------------------------------------------------------------------------------------------------|
| TDESKTOP_BRANCH | Branch of the Telegram Desktop repository. If the source code does already exists, the source won't be cloned. |
