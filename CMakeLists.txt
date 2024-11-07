cmake_minimum_required(VERSION 3.13)

set(PROJECT hello_webgpu)

project(
    ${PROJECT}
    LANGUAGES CXX C
)

find_package(Dawn REQUIRED)
# if(Dawn_FOUND)  
#     add_library(dawn::webgpu_dawn SHARED IMPORTED) 
# endif(Dawn_FOUND)  

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
# https://discourse.cmake.org/t/copying-created-shared-libraries/4936/4
# https://discourse.cmake.org/t/usage-of-target-runtime-dlls-generator-expression/6355
add_custom_command(TARGET ${PROJECT}  POST_BUILD
	# essential not to put spaces between '${PROJECT}' and '>' in the next line!!!
  COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_RUNTIME_DLLS:${PROJECT}> $<TARGET_FILE_DIR:${PROJECT}>
  COMMAND_EXPAND_LISTS
)  

# add_custom_command(TARGET ${PROJECT} POST_BUILD
#   COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_RUNTIME_DLLS:${PROJECT}> $<TARGET_FILE_DIR:${PROJECT}>
#   COMMAND_EXPAND_LISTS
# ) 