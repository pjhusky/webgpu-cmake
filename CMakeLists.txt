cmake_minimum_required(VERSION 3.13)

set(WEBGPU_IMPL_STR_WGPU_NATIVE "WEBGPU_WGPU_NATIVE")
set(WEBGPU_IMPL_STR_DAWN "WEBGPU_DAWN")

# # SWITCH for WGPU_NATIVE vs. DAWN
# set(WEBGPU_IMPL_STR ${WEBGPU_IMPL_STR_DAWN})
# # set(WEBGPU_IMPL_STR ${WEBGPU_IMPL_STR_WGPU_NATIVE})


message(status " WEBGPU_IMPL_STR is " '$ENV{WEBGPU_IMPL_STR}')

# in this snippet env var has priority, but want to override on cmd line => give non-env var priority!!!
# https://stackoverflow.com/questions/30136081/compare-the-value-of-an-environment-variable-in-cmakelists-txt
# if (DEFINED ENV{WEBGPU_IMPL_STR}) # without '$' on purpose
# 	if ( "$ENV{WEBGPU_IMPL_STR}" MATCHES "${WEBGPU_IMPL_STR_WGPU_NATIVE}" OR "$ENV{WEBGPU_IMPL_STR}" MATCHES "${WEBGPU_IMPL_STR_DAWN}" )
#  		set(WEBGPU_IMPL_STR "$ENV{WEBGPU_IMPL_STR}")
# 	else()
# 		message( "no known WebGPU implementation selected (${WEBGPU_IMPL_STR_WGPU_NATIVE} or ${WEBGPU_IMPL_STR_DAWN})" )
# 		#return()
# 		message( "defaulting to '${WEBGPU_IMPL_STR_DAWN}'" )
# 		set(WEBGPU_IMPL_STR ${WEBGPU_IMPL_STR_DAWN})
# 	endif()
# 	message( "WEBGPU_IMPL_STR env var = $ENV{WEBGPU_IMPL_STR}" )
# else() # not 
# 	message( "WEBGPU_IMPL_STR Environment variable NOT DEFINED" )
# 	message( "non-env var WEBGPU_IMPL_STR is '${WEBGPU_IMPL_STR}'" )
# 	if ( DEFINED WEBGPU_IMPL_STR ) # on purpose without '$' => https://stackoverflow.com/a/51621325
# 		message( "non-env var WEBGPU_IMPL_STR is defined" )
# 		if ( "${WEBGPU_IMPL_STR}" MATCHES "${WEBGPU_IMPL_STR_WGPU_NATIVE}" OR "${WEBGPU_IMPL_STR}" MATCHES "${WEBGPU_IMPL_STR_DAWN}" )
# 			message( "non-env var WEBGPU_IMPL_STR is set to a known WEBGPU impl, so we use it" )
# 			message( "WEBGPU_IMPL_STR cmake var = ${WEBGPU_IMPL_STR}" )
# 		else()
# 			message( "non-env var WEBGPU_IMPL_STR is NOT set to a known WEBGPU impl, let's fix this" )
# 			message( "defaulting to '${WEBGPU_IMPL_STR_DAWN}'" )
# 			set(WEBGPU_IMPL_STR ${WEBGPU_IMPL_STR_DAWN})		
# 		endif()
# 	else()
# 		message( "defaulting to '${WEBGPU_IMPL_STR_DAWN}'" )
# 		set(WEBGPU_IMPL_STR ${WEBGPU_IMPL_STR_DAWN})
# 	endif()	
# endif()

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
# message( CMAKE_PREFIX_PATH="${CMAKE_PREFIX_PATH}" )
message( "\n")

set(PROJECT hello_webgpu)

project(
    ${PROJECT}
    LANGUAGES CXX C
)



add_compile_definitions( WEBGPU_PROVIDER ${WEBGPU_IMPL_STR})


# add_executable(${PROJECT} hello_webgpu.cpp)
add_executable(${PROJECT} hello_webgpu_c.cpp)

set_target_properties(${PROJECT} PROPERTIES
	CXX_STANDARD 20
	CXX_STANDARD_REQUIRED ON
	CXX_EXTENSIONS OFF
	COMPILE_WARNING_AS_ERROR ON
)

# include_directories(dawn::webgpu_dawn/include) #?




if ( ${WEBGPU_IMPL_STR} STREQUAL ${WEBGPU_IMPL_STR_WGPU_NATIVE} )
	# set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "/opt/homebrew/Cellar/libgit2")
	# set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "/lib")

	find_package(PkgConfig)
	if (PkgConfig_FOUND)
		pkg_check_modules(WGPU_NATIVE wgpu-native)
	else()

		# set(WGPU_NATIVE_INCLUDE_DIRS "C:/DEV/WebGPU_wgpu-native-C-from-rust/wgpu-native/meson-install-release/include")
		# set(WGPU_NATIVE_LIBRARY_DIRS "C:/DEV/WebGPU_wgpu-native-C-from-rust/wgpu-native/meson-install-release/lib")

		foreach( LIST_EL ${CMAKE_PREFIX_PATH} )
			string ( REPLACE "\\" "/" ELEMENT ${LIST_EL} )
			message ( "ELEMENT=${ELEMENT}" )
			# list ( APPEND WGPU_NATIVE_INCLUDE_DIRS "${ELEMENT}/include" )
			# list ( APPEND WGPU_NATIVE_LIBRARY_DIRS "${ELEMENT}/lib" )

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

		
		# https://stackoverflow.com/questions/14077611/how-do-i-tell-cmake-to-link-in-a-static-library-in-the-source-directory
		# when only passing a lib file name, '.lib' will always be appended, but meson builds a lib with the extension '.a'
		# when passing a path, the name is kept, i.e., '.lib' is not appended, thus the file is found!
		# set(WGPU_NATIVE_LIBRARIES ${WGPU_NATIVE_LIBRARY_DIRS}/libwgpu_native.a)
	endif ()
else()
	find_package(Dawn REQUIRED)
endif()




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
			
	if ( MSVC )
		target_link_libraries(${PROJECT}
			PRIVATE
			"WS2_32" "ntdll" "userenv" "advapi32" "shell32" "msvcrt" "Opengl32" "d3dcompiler" )
	endif()
	
	#]=]		
else()
	# Declare dependency on the dawn::webgpu_dawn library
	target_link_libraries(${PROJECT} dawn::webgpu_dawn)
endif()


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


# add_custom_command(TARGET ${PROJECT} POST_BUILD
#   COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_RUNTIME_DLLS:${PROJECT}> $<TARGET_FILE_DIR:${PROJECT}>
#   COMMAND_EXPAND_LISTS
# ) 