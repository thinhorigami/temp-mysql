cmake_minimum_required(VERSION 3.25)

project(chess)

set (CMAKE_CXX_STANDARD 23)
set (CMAKE_CXX_STANDARD_REQUIRED ON)

include (${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
conan_basic_setup()

list (APPEND CMAKE_MODULE_PATH ${CMAKE_BINARY_DIR})

add_subdirectory("chess")