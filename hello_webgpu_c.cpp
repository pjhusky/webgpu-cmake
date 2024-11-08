// Include WebGPU header
// #include <webgpu/webgpu.h>
#if ( WEBGPU_PROVIDER == WEBGPU_WGPU_NATIVE )
    #include <webgpu-headers/webgpu.h> 
#else
    #include <webgpu/webgpu.h>
#endif

#include <iostream>

// AFTER ALL INCLUDES
#if 0 && (WEBGPU_PROVIDER == WEBGPU_WGPU_NATIVE )
    // native-static-libs: advapi32.lib ws2_32.lib userenv.lib shell32.lib msvcrt.lib
    #pragma comment(lib,"WS2_32")
    #pragma comment(lib,"ntdll")
    #pragma comment(lib,"userenv")
    #pragma comment(lib,"advapi32")
    #pragma comment(lib,"shell32")
    #pragma comment(lib,"msvcrt")
    #pragma comment(lib,"Opengl32")
    #pragma comment(lib,"d3dcompiler")
#endif


int main (int, char**) {
    
#if ( WEBGPU_PROVIDER == WEBGPU_WGPU_NATIVE )
    std::cout << "WEBGPU_WGPU_NATIVE\n";
#elif ( WEBGPU_PROVIDER == WEBGPU_DAWN )
    std::cout << "WEBGPU_DAWN\n";
#else
    std::cout << "UNKNOWN WEBGPU IMPL\n";
#endif
    
	// We create a descriptor
	WGPUInstanceDescriptor desc = {};
	desc.nextInChain = nullptr;

	// We create the instance using this descriptor
#ifdef WEBGPU_BACKEND_EMSCRIPTEN
	WGPUInstance instance = wgpuCreateInstance(nullptr);
#else //  WEBGPU_BACKEND_EMSCRIPTEN
	WGPUInstance instance = wgpuCreateInstance(&desc);
#endif //  WEBGPU_BACKEND_EMSCRIPTEN

	// We can check whether there is actually an instance created
	if (!instance) {
		std::cerr << "Could not initialize WebGPU!" << std::endl;
		return 1;
	}

	// Display the object (WGPUInstance is a simple pointer, it may be
	// copied around without worrying about its size).
	std::cout << "WGPU instance: " << instance << std::endl;

	// We clean up the WebGPU instance
	wgpuInstanceRelease(instance);

	return 0;
}
