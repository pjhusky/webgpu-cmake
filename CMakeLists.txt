cmake_minimum_required(VERSION 3.13)

set(WEBGPU_IMPL_STR_WGPU_NATIVE "WEBGPU_WGPU_NATIVE")
set(WEBGPU_IMPL_STR_DAWN "WEBGPU_DAWN")

# # SWITCH for WGPU_NATIVE vs. DAWN
# set(WEBGPU_IMPL_STR ${WEBGPU_IMPL_STR_DAWN})
# # set(WEBGPU_IMPL_STR ${WEBGPU_IMPL_STR_WGPU_NATIVE})

message(status " WEBGPU_IMPL_STR is " '$ENV{WEBGPU_IMPL_STR}')

# helper function, try to set the desired WebGPU implementation based on the env var 'WEBGPU_IMPL_STR'
function(TrySetWebGpuFromEnvVar)
	if (DEFINED ENV{WEBGPU_IMPL_STR}) # without '$' on purpose
		if ( "$ENV{WEBGPU_IMPL_STR}" MATCHES "${WEBGPU_IMPL_STR_WGPU_NATIVE}" OR "$ENV{WEBGPU_IMPL_STR}" MATCHES "${WEBGPU_IMPL_STR_DAWN}" )
			message( "ENV VAR: WEBGPU_IMPL_STR is set to a known WEBGPU impl, so we use it" )
			set(WEBGPU_IMPL_STR "$ENV{WEBGPU_IMPL_STR}")
		else()
			message( "ENV VAR: no known WebGPU implementation selected (${WEBGPU_IMPL_STR_WGPU_NATIVE} or ${WEBGPU_IMPL_STR_DAWN})" )
			#return()
			# message( "defaulting to '${WEBGPU_IMPL_STR_DAWN}'" )
			# set(WEBGPU_IMPL_STR ${WEBGPU_IMPL_STR_DAWN})
		endif()
		# message( "WEBGPU_IMPL_STR env var = $ENV{WEBGPU_IMPL_STR}" )
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
	if ( "${WEBGPU_IMPL_STR}" MATCHES "${WEBGPU_IMPL_STR_WGPU_NATIVE}" OR "${WEBGPU_IMPL_STR}" MATCHES "${WEBGPU_IMPL_STR_DAWN}" )
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
	message( "defaulting to '${WEBGPU_IMPL_STR_DAWN}'" )
	set(WEBGPU_IMPL_STR ${WEBGPU_IMPL_STR_DAWN})
else()
	message( "WEBGPU_IMPL_STR successfully set to '${WEBGPU_IMPL_STR}'" )
endif()





message( "\nCMAKE_PREFIX_PATH=" )
foreach( LIST_EL ${CMAKE_PREFIX_PATH} )
	message( "${LIST_EL}" )	
endforeach( LIST_EL IN ${CMAKE_PREFIX_PATH} )
message( "\n")




set(PROJECT hello_webgpu)

project(
    ${PROJECT}
    LANGUAGES CXX C
)


# https://medium.com/swlh/cpm-an-awesome-dependency-manager-for-c-with-cmake-3c53f4376766

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


add_executable( ${PROJECT} 
	main.cpp
	webgpu-utils.h
	webgpu-utils.cpp
)

add_compile_definitions( WEBGPU_BACKEND ${WEBGPU_IMPL_STR})


# add_executable(${PROJECT} hello_webgpu.cpp) # only works in Dawn (or with a Cpp wrapper for WGPU_Native?)
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

# include_directories(dawn::webgpu_dawn/include) #?

if ( ${WEBGPU_IMPL_STR} STREQUAL ${WEBGPU_IMPL_STR_WGPU_NATIVE} )
	# include(FindPkgConfig)
	# pkg_check_modules(WGPU_NATIVE wgpu-native)

	# 
	# add_library(wgpu-native MODULE IMPORTED)
	add_library(wgpu-native STATIC IMPORTED)
	set_target_properties(wgpu-native PROPERTIES
		INTERFACE_INCLUDE_DIRECTORIES "${_IMPORT_PREFIX}/include"
		#INTERFACE_INCLUDE_DIRECTORIES "C:/DEV/WebGPU_wgpu-native-C-from-rust/wgpu-native/meson-install-release/include"
		#INTERFACE_INCLUDE_DIRECTORIES "${WEBGPU_WGPU_NATIVE_BASE_DIR}/include"
		#INTERFACE_INCLUDE_DIRECTORIES "/include"
		#
		IMPORTED_LOCATION "${_IMPORT_PREFIX}/lib/libwgpu_native.a"
		#IMPORTED_LOCATION "C:/DEV/WebGPU_wgpu-native-C-from-rust/wgpu-native/meson-install-release/lib/libwgpu_native.a"
		#IMPORTED_LOCATION "${WEBGPU_WGPU_NATIVE_BASE_DIR}/lib/libwgpu_native.a"
		#IMPORTED_LOCATION "/lib/libwgpu_native.a"
	)

	find_package( wgpu-native REQUIRED )

	add_library(webgpu ALIAS wgpu-native)
	# # glfw3wegpu assumes that targets 'glfw' and 'webgpu' exist.
	add_subdirectory( glfw3webgpu )
else()
	find_package( Dawn REQUIRED )
	#find_package( Dawn )

	# glfw3wegpu assumes that targets 'glfw' and 'webgpu' exist.
	add_library(webgpu ALIAS dawn::webgpu_dawn)
	add_subdirectory( glfw3webgpu )
endif()


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
# if (GLFW3_ADDED)
#   # while it will build, Intellisense in IDEs have a hard time finding the header(s) without this line
#   include_directories( ${PROJECT} PRIVATE "${GLFW3_SOURCE_DIR}/include" ) # hmmm, seemed to be necessary before, but is no longer necessary now ...

#   # TL;DR:
#   # target_link_libraries() at the very bottom doesn't necessarily reference the lib by file name
#   # through CMake building the "name" may be given independently as the "generic" library name
#   # for glfw lib, the generic name is "glfw" and thus should be used in target_link_libraries(), even when the lib is called glfw3
#   # => to make it a bit more intuitive, we can introduce an alias name, though, through add_library( .. ALIAS .. )
  
# # https://cmake.org/cmake/help/latest/command/target_link_libraries.html
# #   The named target must be created by add_library() within the project or as an IMPORTED library.
# #   ==> <project-dir>\build_CPM_SRC_CACHE\glfw3\9fc60ad2c810b92f74235a589a9a0edee75bc2d3\src\CMakeLists.txt
# #     add_library(glfw ${GLFW_LIBRARY_TYPE}
# #                 "${GLFW_SOURCE_DIR}/include/GLFW/glfw3.h"
# #                 "${GLFW_SOURCE_DIR}/include/GLFW/glfw3native.h"
# #                 internal.h platform.h mappings.h
# #                 ... null_window.c null_joystick.c)

# # https://cmake.org/cmake/help/latest/command/add_library.html#alias-libraries
# # Creates an Alias Target, such that <name> can be used to refer to <target> in subsequent commands.
# # Just so that linking is more intuitive - the file is called libglfw3.a after all, i.e., WITH the number '3' in the name, not just plain glfw
#   add_library(glfw3 ALIAS glfw)

# endif()


# include_directories(
# 	dawn::webgpu_dawn
# )



# target_link_libraries( ${PROJECT} PRIVATE glfw3webgpu )



#[==[
if ( ${WEBGPU_IMPL_STR} STREQUAL ${WEBGPU_IMPL_STR_WGPU_NATIVE} )
	# set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "/opt/homebrew/Cellar/libgit2")
	# set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "/lib")

	find_package(PkgConfig)
	if (PkgConfig_FOUND)
		pkg_check_modules(WGPU_NATIVE wgpu-native)
	else()

		if ( DEFINED WEBGPU_WGPU_NATIVE_BASE_DIR )
			message( "WEBGPU_WGPU_NATIVE_BASE_DIR was given on the cmake cmd line: '${WEBGPU_WGPU_NATIVE_BASE_DIR}'" )

			target_include_directories(${PROJECT}
				PRIVATE
				"${WEBGPU_WGPU_NATIVE_BASE_DIR}/include")

			target_link_directories(${PROJECT}
				PRIVATE
				"${WEBGPU_WGPU_NATIVE_BASE_DIR}/lib")

			if ( EXISTS "${WEBGPU_WGPU_NATIVE_BASE_DIR}/lib/libwgpu_native.a" )
				target_link_libraries(${PROJECT}
					PRIVATE
					"${WEBGPU_WGPU_NATIVE_BASE_DIR}/lib/libwgpu_native.a")
			endif()

		else()  # try to find the correct lib location based on CMAKE_PREFIX_PATH
		
			# set(WGPU_NATIVE_INCLUDE_DIRS "C:/DEV/WebGPU_wgpu-native-C-from-rust/wgpu-native/meson-install-release/include")
			# set(WGPU_NATIVE_LIBRARY_DIRS "C:/DEV/WebGPU_wgpu-native-C-from-rust/wgpu-native/meson-install-release/lib")

			# https://stackoverflow.com/questions/14077611/how-do-i-tell-cmake-to-link-in-a-static-library-in-the-source-directory
			# when only passing a lib file name, '.lib' will always be appended, but meson builds a lib with the extension '.a'
			# when passing a path, the name is kept, i.e., '.lib' is not appended, thus the file is found!
			# set(WGPU_NATIVE_LIBRARIES ${WGPU_NATIVE_LIBRARY_DIRS}/libwgpu_native.a)

			foreach( LIST_EL ${CMAKE_PREFIX_PATH} )
				string ( REPLACE "\\" "/" ELEMENT ${LIST_EL} )
				message ( "ELEMENT=${ELEMENT}" )

				target_include_directories(${PROJECT}
					PRIVATE
					"${ELEMENT}/include")

				target_link_directories(${PROJECT}
					PRIVATE
					"${ELEMENT}/lib")

				if ( EXISTS "${ELEMENT}/lib/libwgpu_native.a" )
					target_link_libraries(${PROJECT}
						PRIVATE
						"${ELEMENT}/lib/libwgpu_native.a")
						

				endif()
				
			endforeach( LIST_EL IN ${CMAKE_PREFIX_PATH} )
		endif()		
	endif ()
else()
	find_package(Dawn REQUIRED)
endif()
#]==]



if ( ${WEBGPU_IMPL_STR} STREQUAL ${WEBGPU_IMPL_STR_WGPU_NATIVE} )
	# [=[
	# target_include_directories(${PROJECT}
	# 		PRIVATE
	# 		${WGPU_NATIVE_INCLUDE_DIRS})

	# target_link_directories(${PROJECT}
	# 		PRIVATE
	# 		${WGPU_NATIVE_LIBRARY_DIRS})

	# target_link_libraries(${PROJECT}
	# 		PRIVATE
	# 		${WGPU_NATIVE_LIBRARIES})
	
					# find_package( wgpu-native )
					# add_library(webgpu ALIAS wgpu-native)
					# # glfw3wegpu assumes that targets 'glfw' and 'webgpu' exist.
					# add_subdirectory( glfw3webgpu )
	
	if ( MSVC )


		target_link_libraries(${PROJECT}
			PRIVATE
			"WS2_32" "ntdll" "userenv" "advapi32" "shell32" "msvcrt" "Opengl32" "d3dcompiler" 
			glfw3 glfw3webgpu )
	endif()
	
	#]=]		
else()
	# Declare dependency on the dawn::webgpu_dawn library
	# target_link_libraries( ${PROJECT} dawn::webgpu_dawn glfw3webgpu )
	target_link_libraries( ${PROJECT} dawn::webgpu_dawn glfw3 glfw3webgpu )

	# target_include_directories( ${PROJECT}
	# 	PRIVATE
	# 	dawn::webgpu_dawn
	# )

	# copy dawn dll
	# https://discourse.cmake.org/t/copying-created-shared-libraries/4936/4
	# https://discourse.cmake.org/t/usage-of-target-runtime-dlls-generator-expression/6355
	#[=[
	add_custom_command(TARGET ${PROJECT}  POST_BUILD
		# essential not to put spaces between '${PROJECT}' and '>' in the next line!!!
	COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_RUNTIME_DLLS:${PROJECT}> $<TARGET_FILE_DIR:${PROJECT}>
	COMMAND_EXPAND_LISTS
	)  
	#]=]

	add_custom_command(TARGET ${PROJECT} POST_BUILD
	  COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_RUNTIME_DLLS:${PROJECT}> $<TARGET_FILE_DIR:${PROJECT}>
	  COMMAND_EXPAND_LISTS
	) 
endif()


