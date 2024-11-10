@ECHO: Make sure to define the path to the Dawn install dir
@ECHO OFF
setlocal

@REM
@ECHO WARNING: KEEP THESE STRINGS iN SYNC WITH CMakeLists.txt
@REM @set WEBGPU_IMPL_STR="WEBGPU_IMPL_WGPU_NATIVE"
@REM 
@set WEBGPU_IMPL_STR="WEBGPU_IMPL_DAWN"

@set MY_CMAKE_PREFIX_PATH="C:\DEV\WebGPU_dawn\dawn\install\Release;C:\DEV\WebGPU_wgpu-native-C-from-rust\wgpu-native\meson-install-release" 
@set MY_WEBGPU_WGPU_NATIVE_BASE_DIR="C:\DEV\WebGPU_wgpu-native-C-from-rust\wgpu-native\meson-install-release"
@set CMAKE_GEN_BUILD_FILE_CMD=cmake -S . -B .\build -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=%MY_CMAKE_PREFIX_PATH% -DWEBGPU_IMPL_STR=%WEBGPU_IMPL_STR% -DWEBGPU_WGPU_NATIVE_BASE_DIR=%MY_WEBGPU_WGPU_NATIVE_BASE_DIR%

@set OPTIONAL_TARGET=

IF "%~1"=="" (
    @echo No argument passed to "%~0"
) ELSE IF "%~1"=="clean" (
    @echo Argument is 'clean'.
    @set OPTIONAL_TARGET="--target clean"
) ELSE (
    @echo Argument is not 'clean'.
)
%CMAKE_GEN_BUILD_FILE_CMD% && cmake --build .\build --config Release %OPTIONAL_TARGET% 

@ECHO ON
