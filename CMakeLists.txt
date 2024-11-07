cmake_minimum_required(VERSION 3.13)

set(PROJECT hello_webgpu)

project(
    ${PROJECT}
    LANGUAGES CXX C
)

find_package(Dawn REQUIRED)
add_executable(${PROJECT} hello_webgpu.cpp)

set_target_properties(${PROJECT} PROPERTIES
	CXX_STANDARD 20
	CXX_STANDARD_REQUIRED ON
	CXX_EXTENSIONS OFF
	COMPILE_WARNING_AS_ERROR ON
)

# include_directories(dawn::webgpu_dawn/include) #?

# add_library(dawn::webgpu_dawn SHARED IMPORTED GLOBAL)
#add_library(dawn::webgpu_dawn SHARED IMPORTED GLOBAL)


# Declare dependency on the dawn::webgpu_dawn library
target_link_libraries(${PROJECT} dawn::webgpu_dawn)
#target_link_libraries(${PROJECT})

# copy dawn dll
# add_custom_command(${PROJECT} exe POST_BUILD
#   COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_RUNTIME_DLLS:exe> $<TARGET_FILE_DIR:exe>
#   COMMAND_EXPAND_LISTS
#   )
  
# add_custom_command((${PROJECT} exe POST_BUILD
#                            COMMAND ${CMAKE_COMMAND} -E copy
#                                    #${CMAKE_INSTALL_PREFIX}/bin/Open3D.dll
#                                    $<TARGET_FILE:dawn::webgpu_dawn>
#                                    #${CMAKE_CURRENT_BINARY_DIR}/$<CONFIG>)
#                                    $<TARGET_FILE_DIR:exe> COMMAND_EXPAND_LISTS )

# add_custom_command(${PROJECT} exe POST_BUILD
#   COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:dawn::webgpu_dawn> $<TARGET_FILE_DIR:exe>
#   COMMAND_EXPAND_LISTS
#   )
