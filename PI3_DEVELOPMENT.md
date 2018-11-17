# Cross-compile raspberry-pi (Nov. 2018)

Before running this tutorial - please ensure:

- Ensure Docker is installed - follow instructions for the OS you are running.
- Create a folder to store Docker images and workspace (I use `~/docker/rpi`)

## Global references

- `$DOCKER_HOME`: Directory where Docker images are stored

### Setting up Docker Environment

1. Create workspace folders
```sh
cd $DOCKER_HOME
mkdir project workspace
``` 

2. Create docker-compose.yml
```

```

***NOTE: I keep updated Docker/docker-compose.yml files [here](https://gist.github.com/nkreeger)***

### Clone and build linux kernel

### Clone and build libdrm

### Clone and build mesa

### Clone and build xserver

```sh
git clone git://anongit.freedesktop.org/git/xorg/proto/xorgproto
cd xorgproto && ./autogen.sh --prefix=/usr && make && make install
```

```sh
git clone git://git.freedesktop.org/git/xorg/lib/libXfont
cd libXfont && ./autogen.sh --prefix=/usr --libdir=/usr/lib/arm-linux-gnueabihf && make && make install
```

```sh
git clone git://git.freedesktop.org/git/xorg/xserver

pi2meson \
  -Dlog_dir=/var/log \
  "$@"
```

