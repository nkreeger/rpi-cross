./pi3_meson.sh \
  -Dtexture-float=true \
  -Ddri-drivers= \
  -Dgallium-drivers=vc4,swrast \
  -Dvulkan-drivers= \
  -Dllvm=false \
  -Dplatforms=x11,drm,surfaceless \
  -Dlibunwind=false \
  -Dllvm=false \
  "$@"
