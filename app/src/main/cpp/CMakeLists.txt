# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(harmony_vpn)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

add_library(app SHARED libapp.cpp)
target_link_libraries(app PUBLIC libace_napi.z.so)
target_link_libraries(app PUBLIC libhilog_ndk.z.so)
target_link_libraries(app PUBLIC ${NATIVERENDER_ROOT_PATH}/../../../libs/${OHOS_ARCH}/libohos.so)
target_link_libraries(app PUBLIC ${NATIVERENDER_ROOT_PATH}/../../../libs/${OHOS_ARCH}/libxray.so)