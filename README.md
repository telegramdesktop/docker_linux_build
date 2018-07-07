# Docker image to build the linux version of Telegram Desktop

This repo contains the docker image to build the Linux version of Telegram Desktop with just a few commands!

## Dependencies

- Docker version 17.05 or above

## Usage

If you want to build your own version of Telegram Desktop, mount the folder `/TBuild/tdesktop` to your host and place your source into the folder.

1. Build the Docker image (this may take a few hours):

```
./build_image.sh
```

You can use multi-stage builds here. See the "Multi-stage build" section for more details.

2. Run a new container:

```
./docker_run.sh
```

This will clone the repository to your container and build Telegram Desktop.
You can use flags to set environment variables to the build process. See the "Available flags" section for more details.

3. The binary will be placed on a new created `bin` folder of the current directory.

## Rebuilding

If you want to rebuild Telegram Desktop on your existing Docker image, first delete or rename any container named "tdesktop-linux" on your system:

```
docker rm tdesktop-linux
```

or

```
docker rename tdesktop-linux NEW_NAME
```

Then run steps 2 and 3 from the section above.

## Multi-stage build

- Install the first list of dependencies:

```
./build_image.sh dependencies1
```

- Install the second list of dependencies from the first image:

```
./build_image.sh dependencies2
```

## Available flags

Usage: `./docker_run.sh [flag <option>]`

| Flag | Description                                                                                                    | Default | Example                    |
|------|----------------------------------------------------------------------------------------------------------------|---------|----------------------------|
| -b   | Branch of the Telegram Desktop repository. If the source code does already exists, the source won't be cloned. | master  | `./docker_run.sh -b dev`   |
| -v   | Build version of Telegram Desktop. Options available are "Debug" and "Release".                                  | Release | `./docker_run.sh -v Debug` |
| -m   | Multithreaded make parameter that is used to compile all dependencies and the Telegram Desktop itself.         | -j8     | `./docker_run.sh -m -j4`   |
