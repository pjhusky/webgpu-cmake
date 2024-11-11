@ECHO: Make sure to define the path to the Dawn install dir
@ECHO OFF
setlocal ENABLEDELAYEDEXPANSION

@REM set BUILD_CONFIG=Debug
@REM 
set BUILD_CONFIG=Release

@REM
@ECHO WARNING: KEEP THESE STRINGS iN SYNC WITH CMakeLists.txt
@REM set WEBGPU_IMPL_STR="WEBGPU_IMPL_WGPU_NATIVE"
@REM 
set WEBGPU_IMPL_STR="WEBGPU_IMPL_DAWN"
@REM set WEBGPU_IMPL_STR="WEBGPU_IMPL_EMSCRIPTEN"

set PREFIX_CMD=
set BACKEND=
set BUILD_DIR=.\build
IF %WEBGPU_IMPL_STR%=="WEBGPU_IMPL_WGPU_NATIVE" (
    @REM set BUILD_DIR=".\build\wgpu_native\%BUILD_CONFIG%"
    set BACKEND=wgpu_native
    echo BACKEND='!BACKEND!'
    set BUILD_DIR=.\build\!BACKEND!
    echo BUILD_DIR in='!BUILD_DIR!'
)
IF %WEBGPU_IMPL_STR%=="WEBGPU_IMPL_DAWN" (
    @REM set BUILD_DIR=".\build\dawn\%BUILD_CONFIG%"
    set BACKEND=dawn
    set BUILD_DIR=.\build\!BACKEND!
)
IF %WEBGPU_IMPL_STR%=="WEBGPU_IMPL_EMSCRIPTEN" (
    @REM set PREFIX_CMD="%EMSDK%\upstream\emscripten\emcmake"
    set PREFIX_CMD="C:\DEV\emscripten\emsdk\upstream\emscripten\emcmake.bat"
    @REM set BUILD_DIR=".\build\web"
    set BACKEND=web
    set BUILD_DIR=.\build\!BACKEND!\!BUILD_CONFIG!
)

@ECHO.
@ECHO ##############################
@ECHO BUILD_DIR='%BUILD_DIR%'
@ECHO BACKEND='%BACKEND%'
@ECHO BUILD_CONFIG='%BUILD_CONFIG%'
@ECHO PREFIX_CMD='%PREFIX_CMD%'
@ECHO ##############################
@ECHO.

@REM https://cmake.org/cmake/help/latest/command/find_package.html#command:find_package
@REM https://cmake.org/cmake/help/latest/command/find_package.html#search-procedure

@REM @set MY_CMAKE_PREFIX_PATH="C:\DEV\WebGPU_dawn\dawn\install\Release;C:\DEV\WebGPU_wgpu-native-C-from-rust\wgpu-native\meson-install-release" 
@REM 
@set MY_CMAKE_PREFIX_PATH="C:/DEV/WebGPU_dawn/dawn/install/Debug;C:/DEV/WebGPU_dawn/dawn/install/Release;C:/DEV/WebGPU_wgpu-native-C-from-rust/wgpu-native/meson-install-release" 
@REM @set MY_CMAKE_PREFIX_PATH="C:\DEV\WebGPU_dawn\dawn\install\%BUILD_CONFIG%;C:\DEV\WebGPU_wgpu-native-C-from-rust\wgpu-native\meson-install-release" 
@REM @set MY_CMAKE_PREFIX_PATH="C:\DEV\WebGPU_dawn\dawn\install\%BUILD_CONFIG%\lib\cmake\Dawn;C:\DEV\WebGPU_wgpu-native-C-from-rust\wgpu-native\meson-install-release" 
@REM @set MY_CMAKE_PREFIX_PATH="C:\DEV\WebGPU_dawn\dawn\install;C:\DEV\WebGPU_wgpu-native-C-from-rust\wgpu-native\meson-install-release" 


@REM @set MY_WEBGPU_DAWN_BASE_DIR="%BUILD_CONFIG%\lib\cmake\Dawn"

@set MY_WEBGPU_DAWN_BASE_DIR=C:/DEV/WebGPU_dawn/dawn/install

@set MY_WEBGPU_WGPU_NATIVE_BASE_DIR="C:\DEV\WebGPU_wgpu-native-C-from-rust\wgpu-native\meson-install-release"
@set CMAKE_GEN_BUILD_FILE_CMD=%PREFIX_CMD% cmake -S . -B %BUILD_DIR% -DCMAKE_BUILD_TYPE=%BUILD_CONFIG% -DCMAKE_PREFIX_PATH=%MY_CMAKE_PREFIX_PATH% -DCMAKE_MODULE_PATH=%MY_CMAKE_PREFIX_PATH% -DWEBGPU_IMPL_STR=%WEBGPU_IMPL_STR% -DWEBGPU_WGPU_NATIVE_BASE_DIR=%MY_WEBGPU_WGPU_NATIVE_BASE_DIR% -DWEBGPU_DAWN_BASE_DIR=%MY_WEBGPU_DAWN_BASE_DIR% 

@set OPTIONAL_TARGET=

IF "%~1"=="" (
    @echo No argument passed to "%~0"
) ELSE IF "%~1"=="clean" (
    @echo Argument is 'clean'.
    @set OPTIONAL_TARGET="--target clean"
) ELSE (
    @echo Argument is not 'clean'.
)
@REM %CMAKE_GEN_BUILD_FILE_CMD% && cmake --build .\build --config Release %OPTIONAL_TARGET% 
CALL %CMAKE_GEN_BUILD_FILE_CMD% && cmake --build %BUILD_DIR% --config %BUILD_CONFIG% %OPTIONAL_TARGET% 

@ECHO.
@ECHO --- Done building ---
@ECHO.

IF %WEBGPU_IMPL_STR%=="WEBGPU_IMPL_EMSCRIPTEN" (
    start python -m http.server -d %BUILD_DIR% 
    @ECHO now browse to http://localhost:8000/hello_webgpu.html
)

@ECHO ON
