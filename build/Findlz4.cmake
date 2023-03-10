

function(conan_message MESSAGE_OUTPUT)
    if(NOT CONAN_CMAKE_SILENT_OUTPUT)
        message(${ARGV${0}})
    endif()
endfunction()


macro(conan_find_apple_frameworks FRAMEWORKS_FOUND FRAMEWORKS FRAMEWORKS_DIRS)
    if(APPLE)
        foreach(_FRAMEWORK ${FRAMEWORKS})
            # https://cmake.org/pipermail/cmake-developers/2017-August/030199.html
            find_library(CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND NAMES ${_FRAMEWORK} PATHS ${FRAMEWORKS_DIRS} CMAKE_FIND_ROOT_PATH_BOTH)
            if(CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND)
                list(APPEND ${FRAMEWORKS_FOUND} ${CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND})
            else()
                message(FATAL_ERROR "Framework library ${_FRAMEWORK} not found in paths: ${FRAMEWORKS_DIRS}")
            endif()
        endforeach()
    endif()
endmacro()


function(conan_package_library_targets libraries package_libdir deps out_libraries out_libraries_target build_type package_name)
    unset(_CONAN_ACTUAL_TARGETS CACHE)
    unset(_CONAN_FOUND_SYSTEM_LIBS CACHE)
    foreach(_LIBRARY_NAME ${libraries})
        find_library(CONAN_FOUND_LIBRARY NAMES ${_LIBRARY_NAME} PATHS ${package_libdir}
                     NO_DEFAULT_PATH NO_CMAKE_FIND_ROOT_PATH)
        if(CONAN_FOUND_LIBRARY)
            conan_message(STATUS "Library ${_LIBRARY_NAME} found ${CONAN_FOUND_LIBRARY}")
            list(APPEND _out_libraries ${CONAN_FOUND_LIBRARY})
            if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
                # Create a micro-target for each lib/a found
                string(REGEX REPLACE "[^A-Za-z0-9.+_-]" "_" _LIBRARY_NAME ${_LIBRARY_NAME})
                set(_LIB_NAME CONAN_LIB::${package_name}_${_LIBRARY_NAME}${build_type})
                if(NOT TARGET ${_LIB_NAME})
                    # Create a micro-target for each lib/a found
                    add_library(${_LIB_NAME} UNKNOWN IMPORTED)
                    set_target_properties(${_LIB_NAME} PROPERTIES IMPORTED_LOCATION ${CONAN_FOUND_LIBRARY})
                    set(_CONAN_ACTUAL_TARGETS ${_CONAN_ACTUAL_TARGETS} ${_LIB_NAME})
                else()
                    conan_message(STATUS "Skipping already existing target: ${_LIB_NAME}")
                endif()
                list(APPEND _out_libraries_target ${_LIB_NAME})
            endif()
            conan_message(STATUS "Found: ${CONAN_FOUND_LIBRARY}")
        else()
            conan_message(STATUS "Library ${_LIBRARY_NAME} not found in package, might be system one")
            list(APPEND _out_libraries_target ${_LIBRARY_NAME})
            list(APPEND _out_libraries ${_LIBRARY_NAME})
            set(_CONAN_FOUND_SYSTEM_LIBS "${_CONAN_FOUND_SYSTEM_LIBS};${_LIBRARY_NAME}")
        endif()
        unset(CONAN_FOUND_LIBRARY CACHE)
    endforeach()

    if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
        # Add all dependencies to all targets
        string(REPLACE " " ";" deps_list "${deps}")
        foreach(_CONAN_ACTUAL_TARGET ${_CONAN_ACTUAL_TARGETS})
            set_property(TARGET ${_CONAN_ACTUAL_TARGET} PROPERTY INTERFACE_LINK_LIBRARIES "${_CONAN_FOUND_SYSTEM_LIBS};${deps_list}")
        endforeach()
    endif()

    set(${out_libraries} ${_out_libraries} PARENT_SCOPE)
    set(${out_libraries_target} ${_out_libraries_target} PARENT_SCOPE)
endfunction()


include(FindPackageHandleStandardArgs)

conan_message(STATUS "Conan: Using autogenerated Findlz4.cmake")
# Global approach
set(lz4_FOUND 1)
set(lz4_VERSION "1.9.4")

find_package_handle_standard_args(lz4 REQUIRED_VARS
                                  lz4_VERSION VERSION_VAR lz4_VERSION)
mark_as_advanced(lz4_FOUND lz4_VERSION)


set(lz4_INCLUDE_DIRS "/home/thinhorigami/.conan/data/lz4/1.9.4/_/_/package/2a19826344ff00be1c04403f2f8e7008ed3a7cc6/include")
set(lz4_INCLUDE_DIR "/home/thinhorigami/.conan/data/lz4/1.9.4/_/_/package/2a19826344ff00be1c04403f2f8e7008ed3a7cc6/include")
set(lz4_INCLUDES "/home/thinhorigami/.conan/data/lz4/1.9.4/_/_/package/2a19826344ff00be1c04403f2f8e7008ed3a7cc6/include")
set(lz4_RES_DIRS )
set(lz4_DEFINITIONS )
set(lz4_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(lz4_COMPILE_DEFINITIONS )
set(lz4_COMPILE_OPTIONS_LIST "" "")
set(lz4_COMPILE_OPTIONS_C "")
set(lz4_COMPILE_OPTIONS_CXX "")
set(lz4_LIBRARIES_TARGETS "") # Will be filled later, if CMake 3
set(lz4_LIBRARIES "") # Will be filled later
set(lz4_LIBS "") # Same as lz4_LIBRARIES
set(lz4_SYSTEM_LIBS )
set(lz4_FRAMEWORK_DIRS )
set(lz4_FRAMEWORKS )
set(lz4_FRAMEWORKS_FOUND "") # Will be filled later
set(lz4_BUILD_MODULES_PATHS "/home/thinhorigami/.conan/data/lz4/1.9.4/_/_/package/2a19826344ff00be1c04403f2f8e7008ed3a7cc6/lib/cmake/conan-official-lz4-targets.cmake")

conan_find_apple_frameworks(lz4_FRAMEWORKS_FOUND "${lz4_FRAMEWORKS}" "${lz4_FRAMEWORK_DIRS}")

mark_as_advanced(lz4_INCLUDE_DIRS
                 lz4_INCLUDE_DIR
                 lz4_INCLUDES
                 lz4_DEFINITIONS
                 lz4_LINKER_FLAGS_LIST
                 lz4_COMPILE_DEFINITIONS
                 lz4_COMPILE_OPTIONS_LIST
                 lz4_LIBRARIES
                 lz4_LIBS
                 lz4_LIBRARIES_TARGETS)

# Find the real .lib/.a and add them to lz4_LIBS and lz4_LIBRARY_LIST
set(lz4_LIBRARY_LIST lz4)
set(lz4_LIB_DIRS "/home/thinhorigami/.conan/data/lz4/1.9.4/_/_/package/2a19826344ff00be1c04403f2f8e7008ed3a7cc6/lib")

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_lz4_DEPENDENCIES "${lz4_FRAMEWORKS_FOUND} ${lz4_SYSTEM_LIBS} ")

conan_package_library_targets("${lz4_LIBRARY_LIST}"  # libraries
                              "${lz4_LIB_DIRS}"      # package_libdir
                              "${_lz4_DEPENDENCIES}"  # deps
                              lz4_LIBRARIES            # out_libraries
                              lz4_LIBRARIES_TARGETS    # out_libraries_targets
                              ""                          # build_type
                              "lz4")                                      # package_name

set(lz4_LIBS ${lz4_LIBRARIES})

foreach(_FRAMEWORK ${lz4_FRAMEWORKS_FOUND})
    list(APPEND lz4_LIBRARIES_TARGETS ${_FRAMEWORK})
    list(APPEND lz4_LIBRARIES ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${lz4_SYSTEM_LIBS})
    list(APPEND lz4_LIBRARIES_TARGETS ${_SYSTEM_LIB})
    list(APPEND lz4_LIBRARIES ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(lz4_LIBRARIES_TARGETS "${lz4_LIBRARIES_TARGETS};")
set(lz4_LIBRARIES "${lz4_LIBRARIES};")

set(CMAKE_MODULE_PATH "/home/thinhorigami/.conan/data/lz4/1.9.4/_/_/package/2a19826344ff00be1c04403f2f8e7008ed3a7cc6/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/home/thinhorigami/.conan/data/lz4/1.9.4/_/_/package/2a19826344ff00be1c04403f2f8e7008ed3a7cc6/" ${CMAKE_PREFIX_PATH})

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    # Target approach
    if(NOT TARGET lz4::lz4)
        add_library(lz4::lz4 INTERFACE IMPORTED)
        if(lz4_INCLUDE_DIRS)
            set_target_properties(lz4::lz4 PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                                  "${lz4_INCLUDE_DIRS}")
        endif()
        set_property(TARGET lz4::lz4 PROPERTY INTERFACE_LINK_LIBRARIES
                     "${lz4_LIBRARIES_TARGETS};${lz4_LINKER_FLAGS_LIST}")
        set_property(TARGET lz4::lz4 PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     ${lz4_COMPILE_DEFINITIONS})
        set_property(TARGET lz4::lz4 PROPERTY INTERFACE_COMPILE_OPTIONS
                     "${lz4_COMPILE_OPTIONS_LIST}")
        
    endif()
endif()

foreach(_BUILD_MODULE_PATH ${lz4_BUILD_MODULES_PATHS})
    include(${_BUILD_MODULE_PATH})
endforeach()
