@ECHO: Make sure to define the path to the Dawn install dir
cmake -S . -B .\build -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="C:\DEV\WebGPU_dawn\dawn\install\Release;C:\DEV\WebGPU_wgpu-native-C-from-rust\wgpu-native\meson-install-release" -DWEBGPU_IMPL_STR="WEBGPU_WGPU_NATIVE" && cmake --build .\build --config Release
