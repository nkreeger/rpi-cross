# Setup meson to cross-compile for RPI Arm7
meson build/ \
  --cross-file=$HOME/workspace/rpi-cross/cross \
  --prefix=/usr \
  --libdir=lib/arm-linux-gnueabihf \
  "$@"
