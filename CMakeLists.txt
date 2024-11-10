cmake_minimum_required(VERSION 3.13)

# WARNING: KEEP THESE STRINGS iN SYNC WITH build_win.bat
message( "WARNING: KEEP THESE STRINGS iN SYNC WITH build_win.bat" )
set(WEBGPU_IMPL_WGPU_NATIVE_NAME "WEBGPU_IMPL_WGPU_NATIVE")
set(WEBGPU_IMPL_DAWN_NAME "WEBGPU_IMPL_DAWN")

# # SWITCH for WGPU_NATIVE vs. DAWN
# set(WEBGPU_IMPL_STR ${WEBGPU_IMPL_DAWN_NAME})
# # set(WEBGPU_IMPL_STR ${WEBGPU_IMPL_WGPU_NATIVE_NAME})

message( STATUS "Initially, WEBGPU_IMPL_STR is '$ENV{WEBGPU_IMPL_STR}'\n" )

# helper function, try to set the desired WebGPU implementation based on the env var 'WEBGPU_IMPL_STR'
function(TrySetWebGpuFromEnvVar)
	if (DEFINED ENV{WEBGPU_IMPL_STR}) # without '$' on purpose
		if ( "$ENV{WEBGPU_IMPL_STR}" MATCHES "${WEBGPU_IMPL_WGPU_NATIVE_NAME}" OR "$ENV{WEBGPU_IMPL_STR}" MATCHES "${WEBGPU_IMPL_DAWN_NAME}" )
			message( "ENV VAR: WEBGPU_IMPL_STR is set to a known WEBGPU impl, so we use it" )
			set(WEBGPU_IMPL_STR "$ENV{WEBGPU_IMPL_STR}")
		else()
			message( "ENV VAR: no known WebGPU implementation selected (${WEBGPU_IMPL_WGPU_NATIVE_NAME} or ${WEBGPU_IMPL_DAWN_NAME})" )
		endif()
	else() # not 
		message( "ENV VAR: WEBGPU_IMPL_STR Environment variable NOT DEFINED" )
	endif()	
endfunction(TrySetWebGpuFromEnvVar)

# try to set the desired WebGPU implementation from either a variable 
# (passed with '-DWEBGPU_IMPL_STR="<str-val>"') or from the env var of the same name 'WEBGPU_IMPL_STR'
# if command-line var is passed it has higher priority than the env var
# either var is only ever used when defined AND set to a known impl
# otherwise we fall back to the Dawn WebGPU implementation
message( "non-env var WEBGPU_IMPL_STR is '${WEBGPU_IMPL_STR}'" )
if ( DEFINED WEBGPU_IMPL_STR ) # on purpose without '$' => https://stackoverflow.com/a/51621325
	message( "non-env var WEBGPU_IMPL_STR is defined" )
	if ( "${WEBGPU_IMPL_STR}" MATCHES "${WEBGPU_IMPL_WGPU_NATIVE_NAME}" OR "${WEBGPU_IMPL_STR}" MATCHES "${WEBGPU_IMPL_DAWN_NAME}" )
		message( "non-env var WEBGPU_IMPL_STR is set to a known WEBGPU impl, so we use it" )
		message( "WEBGPU_IMPL_STR cmake var = ${WEBGPU_IMPL_STR}" )
	else()
		message( "non-env var WEBGPU_IMPL_STR is NOT set to a known WEBGPU impl, try fallback to env var" )
		TrySetWebGpuFromEnvVar()
	endif()
else()
	message( "non-env var WEBGPU_IMPL_STR is NOT defined, try fallback to env var" )
	TrySetWebGpuFromEnvVar()
endif()	

# if neither the variable nor the env-variable were defined and set to a valid value, fallback to the Dawn WebGPU implementation
if ( NOT DEFINED WEBGPU_IMPL_STR )
	message( "defaulting to '${WEBGPU_IMPL_DAWN_NAME}'" )
	set(WEBGPU_IMPL_STR ${WEBGPU_IMPL_DAWN_NAME})
else()
	message( "\n" )
	message( STATUS "WEBGPU_IMPL_STR successfully set to '${WEBGPU_IMPL_STR}'\n" )
endif()


message( "WEBGPU_IMPL_STR = '${WEBGPU_IMPL_STR}'" )
message( "WEBGPU_IMPL_WGPU_NATIVE_NAME = '${WEBGPU_IMPL_WGPU_NATIVE_NAME}'" )
message( "WEBGPU_IMPL_DAWN_NAME = '${WEBGPU_IMPL_DAWN_NAME}'" )

# string( MD5 WEBGPU_IMPL_STR ${WEBGPU_IMPL_STR} )
# string( CONCAT WEBGPU_IMPL_STR_TOKEN "0x" ${WEBGPU_IMPL_STR} "ULL" )

# string( MD5 WEBGPU_IMPL_WGPU_NATIVE_TOKEN ${WEBGPU_IMPL_WGPU_NATIVE_NAME} )
# string( CONCAT WEBGPU_IMPL_WGPU_NATIVE_TOKEN "0x" ${WEBGPU_IMPL_WGPU_NATIVE_TOKEN} "ULL" )

# string( MD5 WEBGPU_IMPL_DAWN_TOKEN ${WEBGPU_IMPL_DAWN_NAME} )
# string( CONCAT WEBGPU_IMPL_DAWN_TOKEN "0x" ${WEBGPU_IMPL_DAWN_TOKEN} "ULL" )

set( WEBGPU_IMPL_WGPU_NATIVE_TOKEN 1 )
set( WEBGPU_IMPL_DAWN_TOKEN 2 )

add_compile_options( 
	-DWEBGPU_IMPL=${WEBGPU_IMPL_STR} 
	-DWEBGPU_IMPL_WGPU_NATIVE=${WEBGPU_IMPL_WGPU_NATIVE_TOKEN} 
	-DWEBGPU_IMPL_DAWN=${WEBGPU_IMPL_DAWN_TOKEN} 
	#
	-DWEBGPU_IMPL_STR="${WEBGPU_IMPL_STR}" 
	-DWEBGPU_IMPL_WGPU_NATIVE_NAME="${WEBGPU_IMPL_WGPU_NATIVE_NAME}" 
	-DWEBGPU_IMPL_DAWN_NAME="${WEBGPU_IMPL_DAWN_NAME}" 
	#
	-DDUMMY=27 ) 


message( "\nCMAKE_PREFIX_PATH=" )
foreach( LIST_EL ${CMAKE_PREFIX_PATH} )
	message( "${LIST_EL}" )	
endforeach( LIST_EL IN ${CMAKE_PREFIX_PATH} )
message( "\n")


message( "Current source dir is ${CMAKE_CURRENT_SOURCE_DIR}" )


set(PROJECT hello_webgpu)

project(
    ${PROJECT}
    LANGUAGES CXX C
)


# https://medium.com/swlh/cpm-an-awesome-dependency-manager-for-c-with-cmake-3c53f4376766
#[==[
# ----------------
# ---  get CPM ---
set(CPM_DOWNLOAD_VERSION 0.27.2) 
set(CPM_DOWNLOAD_LOCATION "${CMAKE_BINARY_DIR}/cmake/CPM_${CPM_DOWNLOAD_VERSION}.cmake")

if(NOT (EXISTS ${CPM_DOWNLOAD_LOCATION}))
    message(STATUS "Downloading CPM.cmake")
    file(DOWNLOAD https://github.com/TheLartians/CPM.cmake/releases/download/v${CPM_DOWNLOAD_VERSION}/CPM.cmake ${CPM_DOWNLOAD_LOCATION})
endif()

include(${CPM_DOWNLOAD_LOCATION})
# --- ~get CPM ---
# ----------------

# https://alandefreitas.github.io/matplotplusplus/integration/cmake/embed-with-cpmcmake/
# or on cmd-line: -DCPM_USE_LOCAL_PACKAGES=ON
option(CPM_USE_LOCAL_PACKAGES "Try `find_package` before downloading dependencies" ON)

#]==]


add_executable( ${PROJECT} 
	main.cpp
	webgpu-utils.h
	webgpu-utils.cpp
)




# add_executable(${PROJECT} hello_webgpu.cpp) # only works in Dawn (or maybe with a Cpp wrapper for WGPU_Native?)
# add_executable(${PROJECT} hello_webgpu_c.cpp)



set_target_properties(${PROJECT} PROPERTIES
	C_STANDARD 20
	C_STANDARD_REQUIRED ON
	C_EXTENSIONS OFF
	CXX_STANDARD 20	
	CXX_STANDARD_REQUIRED ON
	CXX_EXTENSIONS OFF
	COMPILE_WARNING_AS_ERROR ON
)




include(FetchContent)
FetchContent_Declare(
  glfw
  GIT_REPOSITORY https://github.com/glfw/glfw
  GIT_TAG        7b6aead9fb88b3623e3b3725ebb42670cbe4c579 # v 3.4
  SYSTEM
#   OPTIONS
# 	"GLFW_LIBRARY_TYPE STATIC"
# 	# "GLFW_LIBRARY_TYPE OBJECT" # https://www.glfw.org/docs/latest/compile.html
# 	"GLFW_BUILD_TESTS OFF"
# 	"GLFW_BUILD_EXAMPLES OFF"
# 	"GLFW_BUILD_DOCS OFF"
)
# This will try calling find_package() first for both dependencies
FetchContent_MakeAvailable(glfw)
# find_package(glfw3
#     REQUIRED
#     NO_DEFAULT_PATH
#     #PATHS ${mylibrary_SOURCE_DIR}/path/to/dir/containing/*Config.cmake
# 	PATHS ${CMAKE_FIND_PACKAGE_REDIRECTS_DIR}
# )
# FetchContent_Populate(glfw)
#message( "glfw_SOURCE_DIR = '${glfw_SOURCE_DIR}'" )

# https://stackoverflow.com/a/23995391
# add_library(glfw STATIC IMPORTED)
set_target_properties(glfw PROPERTIES
	INTERFACE_INCLUDE_DIRECTORIES "${_IMPORT_PREFIX}/include"
	#INTERFACE_INCLUDE_DIRECTORIES "/include"
	#
	IMPORTED_LOCATION "${_IMPORT_PREFIX}/lib/glfw3"
	#IMPORTED_LOCATION "/lib/libwgpu_native.a"
)
# target_compile_options( glfw3 PRIVATE 
# 	"GLFW_BUILD_TESTS OFF"
#  	"GLFW_BUILD_EXAMPLES OFF"
#  	"GLFW_BUILD_DOCS OFF" )
# https://stackoverflow.com/a/23995391
# target_compile_options(glfw INTERFACE "$<$<CONFIG:DEBUG>:-DGLFW_BUILD_TESTS=OFF -DGLFW_BUILD_EXAMPLES=OFF -DGLFW_BUILD_DOCS=OFF>")
# target_compile_options(glfw INTERFACE "$<$<CONFIG:RELEASE>:-DGLFW_BUILD_TESTS=OFF -DGLFW_BUILD_EXAMPLES=OFF -DGLFW_BUILD_DOCS=OFF>")
target_compile_options(glfw PUBLIC "$<$<CONFIG:DEBUG>:-DGLFW_BUILD_TESTS=OFF -DGLFW_BUILD_EXAMPLES=OFF -DGLFW_BUILD_DOCS=OFF>")
target_compile_options(glfw PUBLIC "$<$<CONFIG:RELEASE>:-DGLFW_BUILD_TESTS=OFF -DGLFW_BUILD_EXAMPLES=OFF -DGLFW_BUILD_DOCS=OFF>")
#find_package( glfw REQUIRED )

# glfw3 == glfw, but more obvious to include version in name
add_library(glfw3 ALIAS glfw)
include_directories( "${glfw_SOURCE_DIR}/include" )




if ( ${WEBGPU_IMPL_STR} STREQUAL ${WEBGPU_IMPL_WGPU_NATIVE_NAME} )

	# 
	add_library(wgpu-native STATIC IMPORTED)
	# https://stackoverflow.com/questions/72362303/how-to-use-fetchcontent-populate-with-eigen
	# message( "wgpu-native_SOURCE_DIR = ${wgpu-native_SOURCE_DIR}" )
	# message( "wgpu-native_BINARY_DIR = ${wgpu-native_BINARY_DIR}" )
	set_target_properties(wgpu-native PROPERTIES
		#INTERFACE_INCLUDE_DIRECTORIES "${_IMPORT_PREFIX}/include" # NOPE
		#INTERFACE_INCLUDE_DIRECTORIES "C:/DEV/WebGPU_wgpu-native-C-from-rust/wgpu-native/meson-install-release/include"
		INTERFACE_INCLUDE_DIRECTORIES "${WEBGPU_WGPU_NATIVE_BASE_DIR}/include;${WEBGPU_WGPU_NATIVE_BASE_DIR}/include/webgpu-headers"
		#INTERFACE_INCLUDE_DIRECTORIES "/include" # NOPE
		#INTERFACE_INCLUDE_DIRECTORIES "${wgpu-native_SOURCE_DIR}/include" # NOPE
		#
		# IMPORTED_LOCATION "${_IMPORT_PREFIX}/lib/libwgpu_native.a" # NOPE
		#IMPORTED_LOCATION "C:/DEV/WebGPU_wgpu-native-C-from-rust/wgpu-native/meson-install-release/lib/libwgpu_native.a"
		IMPORTED_LOCATION "${WEBGPU_WGPU_NATIVE_BASE_DIR}/lib/libwgpu_native.a"
		#IMPORTED_LOCATION "/lib/libwgpu_native.a" # NOPE
		#IMPORTED_LOCATION "${wgpu-native_BINARY_DIR}/lib/libwgpu_native.a" # NOPE
	)
	find_package( wgpu-native REQUIRED )

	# glfw3wegpu assumes that targets 'glfw' and 'webgpu' exist -> fix names
	add_library(webgpu ALIAS wgpu-native)

else()

	find_package( Dawn REQUIRED )
	
	# glfw3wegpu assumes that targets 'glfw' and 'webgpu' exist -> fix names
	add_library(webgpu ALIAS dawn::webgpu_dawn)
	
endif()

# glfw3wegpu assumes that targets 'glfw' and 'webgpu' exist.
add_subdirectory( glfw3webgpu )


#[==[
# find_package( glfw REQUIRED ) # searches only locally
include(FetchContent)
FetchContent_Declare(
  glfw3
  GIT_REPOSITORY https://github.com/glfw/glfw
#   GIT_REPOSITORY git@github.com:glfw/glfw.git
  GIT_TAG        7b6aead9fb88b3623e3b3725ebb42670cbe4c579 # v 3.4
#   OPTIONS
# 	"GLFW_LIBRARY_TYPE STATIC"
# 	# "GLFW_LIBRARY_TYPE OBJECT" # https://www.glfw.org/docs/latest/compile.html
# 	"GLFW_BUILD_TESTS OFF"
# 	"GLFW_BUILD_EXAMPLES OFF"
# 	"GLFW_BUILD_DOCS OFF"
)
# This will try calling find_package() first for both dependencies
FetchContent_MakeAvailable(glfw3)
# find_package(glfw3
#     REQUIRED
#     NO_DEFAULT_PATH
#     #PATHS ${mylibrary_SOURCE_DIR}/path/to/dir/containing/*Config.cmake
# 	PATHS ${CMAKE_FIND_PACKAGE_REDIRECTS_DIR}
# )
# include(CMakeFindDependencyMacro)
# find_dependency(glfw3)


# FetchContent_Populate(glfw3)

#target_link_libraries( ${PROJECT} PRIVATE glfw3 )
# target_link_libraries( ${PROJECT} PRIVATE glfw )
# target_link_libraries( ${PROJECT} PRIVATE glfw3::glfw )

#]==]

# https://github.com/cpm-cmake/CPM.cmake/wiki/More-Snippets
#[==[
CPMAddPackage(
        NAME GLFW3
        GITHUB_REPOSITORY glfw/glfw
        GIT_TAG 3.4
        OPTIONS
          "GLFW_LIBRARY_TYPE STATIC"
          # "GLFW_LIBRARY_TYPE OBJECT" # https://www.glfw.org/docs/latest/compile.html
          "GLFW_BUILD_TESTS OFF"
          "GLFW_BUILD_EXAMPLES OFF"
          "GLFW_BUILD_DOCS OFF"
)
if (GLFW3_ADDED)
    target_include_directories(glfw 
                               PUBLIC $<BUILD_INTERFACE:${GLFW3_BINARY_DIR}>
                               PUBLIC $<INSTALL_INTERFACE:include>)
    # target_include_directories(zlibstatic 
    #                            PUBLIC $<BUILD_INTERFACE:${GLFW3_BINARY_DIR}>
    #                            PUBLIC $<INSTALL_INTERFACE:include>)
    
	target_include_directories( ${PROJECT} PRIVATE "${GLFW3_SOURCE_DIR}/include" )
	
    message(STATUS "Cmake added local GLFW3: ${GLFW3_SOURCE_DIR}")
	add_library(glfw3 ALIAS glfw)
endif()
#]==]



if ( ${WEBGPU_IMPL_STR} STREQUAL ${WEBGPU_IMPL_WGPU_NATIVE_NAME} )
	
	if ( MSVC )
		target_link_libraries(${PROJECT}
			PRIVATE
			#"WS2_32" "ntdll" "userenv" "advapi32" "shell32" "msvcrt" "Opengl32" "d3dcompiler" 
			"WS2_32" "ntdll" "userenv" "advapi32" "shell32"  "Opengl32" "d3dcompiler" 
			glfw3 glfw3webgpu )
			target_link_options(${PROJECT} PUBLIC "$<$<CONFIG:DEBUG>:msvcrtd.lib>")
			target_link_options(${PROJECT} PUBLIC "$<$<CONFIG:RELEASE>:msvcrt.lib>")
	endif()
	
else()
	# Declare dependency on the dawn::webgpu_dawn library
	# target_link_libraries( ${PROJECT} dawn::webgpu_dawn glfw3webgpu )
	target_link_libraries( ${PROJECT} dawn::webgpu_dawn glfw3 glfw3webgpu )

	# copy dawn dll
	# https://discourse.cmake.org/t/copying-created-shared-libraries/4936/4
	# https://discourse.cmake.org/t/usage-of-target-runtime-dlls-generator-expression/6355
	add_custom_command(TARGET ${PROJECT} POST_BUILD
	  COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_RUNTIME_DLLS:${PROJECT}> $<TARGET_FILE_DIR:${PROJECT}>
	  COMMAND_EXPAND_LISTS
	) 
endif()


