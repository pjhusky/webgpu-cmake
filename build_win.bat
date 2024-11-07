@ECHO: Make sure to define the path to the Dawn install dir
cmake -S . -B .\build -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=C:\DEV\WebGPU_dawn\dawn\install\Release
cmake --build .\build --config Release
