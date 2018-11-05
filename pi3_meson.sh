# Setup meson to cross-compile for RPI Arm7
meson build/ \
  --cross-file=$HOME/rpi-cross/cross \
  --prefix=/usr \
  --libdir=lib/arm-linux-gnueabihf \
  -Dtexture-float=true \
  -Ddri-drivers= \
  -Dgallium-drivers=vc4,swrast \
  -Dvulkan-drivers= \
  -Dllvm=false \
  -Dplatforms=x11,drm,surfaceless \
  -Dlibunwind=false \
  -Dllvm=false \
  "$@"
