########## MACROS ###########################################################################
#############################################################################################

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


########### FOUND PACKAGE ###################################################################
#############################################################################################

include(FindPackageHandleStandardArgs)

conan_message(STATUS "Conan: Using autogenerated FindOpenSSL.cmake")
set(OpenSSL_FOUND 1)
set(OpenSSL_VERSION "1.1.1s")

find_package_handle_standard_args(OpenSSL REQUIRED_VARS
                                  OpenSSL_VERSION VERSION_VAR OpenSSL_VERSION)
mark_as_advanced(OpenSSL_FOUND OpenSSL_VERSION)

set(OpenSSL_COMPONENTS OpenSSL::SSL OpenSSL::Crypto)

if(OpenSSL_FIND_COMPONENTS)
    foreach(_FIND_COMPONENT ${OpenSSL_FIND_COMPONENTS})
        list(FIND OpenSSL_COMPONENTS "OpenSSL::${_FIND_COMPONENT}" _index)
        if(${_index} EQUAL -1)
            conan_message(FATAL_ERROR "Conan: Component '${_FIND_COMPONENT}' NOT found in package 'OpenSSL'")
        else()
            conan_message(STATUS "Conan: Component '${_FIND_COMPONENT}' found in package 'OpenSSL'")
        endif()
    endforeach()
endif()

########### VARIABLES #######################################################################
#############################################################################################


set(OpenSSL_INCLUDE_DIRS "/home/thinhorigami/.conan/data/openssl/1.1.1s/_/_/package/2a19826344ff00be1c04403f2f8e7008ed3a7cc6/include")
set(OpenSSL_INCLUDE_DIR "/home/thinhorigami/.conan/data/openssl/1.1.1s/_/_/package/2a19826344ff00be1c04403f2f8e7008ed3a7cc6/include")
set(OpenSSL_INCLUDES "/home/thinhorigami/.conan/data/openssl/1.1.1s/_/_/package/2a19826344ff00be1c04403f2f8e7008ed3a7cc6/include")
set(OpenSSL_RES_DIRS )
set(OpenSSL_DEFINITIONS )
set(OpenSSL_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(OpenSSL_COMPILE_DEFINITIONS )
set(OpenSSL_COMPILE_OPTIONS_LIST "" "")
set(OpenSSL_COMPILE_OPTIONS_C "")
set(OpenSSL_COMPILE_OPTIONS_CXX "")
set(OpenSSL_LIBRARIES_TARGETS "") # Will be filled later, if CMake 3
set(OpenSSL_LIBRARIES "") # Will be filled later
set(OpenSSL_LIBS "") # Same as OpenSSL_LIBRARIES
set(OpenSSL_SYSTEM_LIBS dl pthread rt)
set(OpenSSL_FRAMEWORK_DIRS )
set(OpenSSL_FRAMEWORKS )
set(OpenSSL_FRAMEWORKS_FOUND "") # Will be filled later
set(OpenSSL_BUILD_MODULES_PATHS "/home/thinhorigami/.conan/data/openssl/1.1.1s/_/_/package/2a19826344ff00be1c04403f2f8e7008ed3a7cc6/lib/cmake/conan-official-openssl-variables.cmake")

conan_find_apple_frameworks(OpenSSL_FRAMEWORKS_FOUND "${OpenSSL_FRAMEWORKS}" "${OpenSSL_FRAMEWORK_DIRS}")

mark_as_advanced(OpenSSL_INCLUDE_DIRS
                 OpenSSL_INCLUDE_DIR
                 OpenSSL_INCLUDES
                 OpenSSL_DEFINITIONS
                 OpenSSL_LINKER_FLAGS_LIST
                 OpenSSL_COMPILE_DEFINITIONS
                 OpenSSL_COMPILE_OPTIONS_LIST
                 OpenSSL_LIBRARIES
                 OpenSSL_LIBS
                 OpenSSL_LIBRARIES_TARGETS)

# Find the real .lib/.a and add them to OpenSSL_LIBS and OpenSSL_LIBRARY_LIST
set(OpenSSL_LIBRARY_LIST ssl crypto)
set(OpenSSL_LIB_DIRS "/home/thinhorigami/.conan/data/openssl/1.1.1s/_/_/package/2a19826344ff00be1c04403f2f8e7008ed3a7cc6/lib")

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_OpenSSL_DEPENDENCIES "${OpenSSL_FRAMEWORKS_FOUND} ${OpenSSL_SYSTEM_LIBS} ")

conan_package_library_targets("${OpenSSL_LIBRARY_LIST}"  # libraries
                              "${OpenSSL_LIB_DIRS}"      # package_libdir
                              "${_OpenSSL_DEPENDENCIES}"  # deps
                              OpenSSL_LIBRARIES            # out_libraries
                              OpenSSL_LIBRARIES_TARGETS    # out_libraries_targets
                              ""                          # build_type
                              "OpenSSL")                                      # package_name

set(OpenSSL_LIBS ${OpenSSL_LIBRARIES})

foreach(_FRAMEWORK ${OpenSSL_FRAMEWORKS_FOUND})
    list(APPEND OpenSSL_LIBRARIES_TARGETS ${_FRAMEWORK})
    list(APPEND OpenSSL_LIBRARIES ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${OpenSSL_SYSTEM_LIBS})
    list(APPEND OpenSSL_LIBRARIES_TARGETS ${_SYSTEM_LIB})
    list(APPEND OpenSSL_LIBRARIES ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(OpenSSL_LIBRARIES_TARGETS "${OpenSSL_LIBRARIES_TARGETS};")
set(OpenSSL_LIBRARIES "${OpenSSL_LIBRARIES};")

set(CMAKE_MODULE_PATH  ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH  ${CMAKE_PREFIX_PATH})


########### COMPONENT Crypto VARIABLES #############################################

set(OpenSSL_Crypto_INCLUDE_DIRS "/home/thinhorigami/.conan/data/openssl/1.1.1s/_/_/package/2a19826344ff00be1c04403f2f8e7008ed3a7cc6/include")
set(OpenSSL_Crypto_INCLUDE_DIR "/home/thinhorigami/.conan/data/openssl/1.1.1s/_/_/package/2a19826344ff00be1c04403f2f8e7008ed3a7cc6/include")
set(OpenSSL_Crypto_INCLUDES "/home/thinhorigami/.conan/data/openssl/1.1.1s/_/_/package/2a19826344ff00be1c04403f2f8e7008ed3a7cc6/include")
set(OpenSSL_Crypto_LIB_DIRS "/home/thinhorigami/.conan/data/openssl/1.1.1s/_/_/package/2a19826344ff00be1c04403f2f8e7008ed3a7cc6/lib")
set(OpenSSL_Crypto_RES_DIRS )
set(OpenSSL_Crypto_DEFINITIONS )
set(OpenSSL_Crypto_COMPILE_DEFINITIONS )
set(OpenSSL_Crypto_COMPILE_OPTIONS_C "")
set(OpenSSL_Crypto_COMPILE_OPTIONS_CXX "")
set(OpenSSL_Crypto_LIBS crypto)
set(OpenSSL_Crypto_SYSTEM_LIBS dl rt pthread)
set(OpenSSL_Crypto_FRAMEWORK_DIRS )
set(OpenSSL_Crypto_FRAMEWORKS )
set(OpenSSL_Crypto_BUILD_MODULES_PATHS "/home/thinhorigami/.conan/data/openssl/1.1.1s/_/_/package/2a19826344ff00be1c04403f2f8e7008ed3a7cc6/lib/cmake/conan-official-openssl-variables.cmake")
set(OpenSSL_Crypto_DEPENDENCIES )
set(OpenSSL_Crypto_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)

########### COMPONENT SSL VARIABLES #############################################

set(OpenSSL_SSL_INCLUDE_DIRS "/home/thinhorigami/.conan/data/openssl/1.1.1s/_/_/package/2a19826344ff00be1c04403f2f8e7008ed3a7cc6/include")
set(OpenSSL_SSL_INCLUDE_DIR "/home/thinhorigami/.conan/data/openssl/1.1.1s/_/_/package/2a19826344ff00be1c04403f2f8e7008ed3a7cc6/include")
set(OpenSSL_SSL_INCLUDES "/home/thinhorigami/.conan/data/openssl/1.1.1s/_/_/package/2a19826344ff00be1c04403f2f8e7008ed3a7cc6/include")
set(OpenSSL_SSL_LIB_DIRS "/home/thinhorigami/.conan/data/openssl/1.1.1s/_/_/package/2a19826344ff00be1c04403f2f8e7008ed3a7cc6/lib")
set(OpenSSL_SSL_RES_DIRS )
set(OpenSSL_SSL_DEFINITIONS )
set(OpenSSL_SSL_COMPILE_DEFINITIONS )
set(OpenSSL_SSL_COMPILE_OPTIONS_C "")
set(OpenSSL_SSL_COMPILE_OPTIONS_CXX "")
set(OpenSSL_SSL_LIBS ssl)
set(OpenSSL_SSL_SYSTEM_LIBS dl pthread)
set(OpenSSL_SSL_FRAMEWORK_DIRS )
set(OpenSSL_SSL_FRAMEWORKS )
set(OpenSSL_SSL_BUILD_MODULES_PATHS "/home/thinhorigami/.conan/data/openssl/1.1.1s/_/_/package/2a19826344ff00be1c04403f2f8e7008ed3a7cc6/lib/cmake/conan-official-openssl-variables.cmake")
set(OpenSSL_SSL_DEPENDENCIES OpenSSL::Crypto)
set(OpenSSL_SSL_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)


########## FIND PACKAGE DEPENDENCY ##########################################################
#############################################################################################

include(CMakeFindDependencyMacro)


########## FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #######################################
#############################################################################################

########## COMPONENT Crypto FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(OpenSSL_Crypto_FRAMEWORKS_FOUND "")
conan_find_apple_frameworks(OpenSSL_Crypto_FRAMEWORKS_FOUND "${OpenSSL_Crypto_FRAMEWORKS}" "${OpenSSL_Crypto_FRAMEWORK_DIRS}")

set(OpenSSL_Crypto_LIB_TARGETS "")
set(OpenSSL_Crypto_NOT_USED "")
set(OpenSSL_Crypto_LIBS_FRAMEWORKS_DEPS ${OpenSSL_Crypto_FRAMEWORKS_FOUND} ${OpenSSL_Crypto_SYSTEM_LIBS} ${OpenSSL_Crypto_DEPENDENCIES})
conan_package_library_targets("${OpenSSL_Crypto_LIBS}"
                              "${OpenSSL_Crypto_LIB_DIRS}"
                              "${OpenSSL_Crypto_LIBS_FRAMEWORKS_DEPS}"
                              OpenSSL_Crypto_NOT_USED
                              OpenSSL_Crypto_LIB_TARGETS
                              ""
                              "OpenSSL_Crypto")

set(OpenSSL_Crypto_LINK_LIBS ${OpenSSL_Crypto_LIB_TARGETS} ${OpenSSL_Crypto_LIBS_FRAMEWORKS_DEPS})

set(CMAKE_MODULE_PATH  ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH  ${CMAKE_PREFIX_PATH})

########## COMPONENT SSL FIND LIBRARIES & FRAMEWORKS / DYNAMIC VARS #############

set(OpenSSL_SSL_FRAMEWORKS_FOUND "")
conan_find_apple_frameworks(OpenSSL_SSL_FRAMEWORKS_FOUND "${OpenSSL_SSL_FRAMEWORKS}" "${OpenSSL_SSL_FRAMEWORK_DIRS}")

set(OpenSSL_SSL_LIB_TARGETS "")
set(OpenSSL_SSL_NOT_USED "")
set(OpenSSL_SSL_LIBS_FRAMEWORKS_DEPS ${OpenSSL_SSL_FRAMEWORKS_FOUND} ${OpenSSL_SSL_SYSTEM_LIBS} ${OpenSSL_SSL_DEPENDENCIES})
conan_package_library_targets("${OpenSSL_SSL_LIBS}"
                              "${OpenSSL_SSL_LIB_DIRS}"
                              "${OpenSSL_SSL_LIBS_FRAMEWORKS_DEPS}"
                              OpenSSL_SSL_NOT_USED
                              OpenSSL_SSL_LIB_TARGETS
                              ""
                              "OpenSSL_SSL")

set(OpenSSL_SSL_LINK_LIBS ${OpenSSL_SSL_LIB_TARGETS} ${OpenSSL_SSL_LIBS_FRAMEWORKS_DEPS})

set(CMAKE_MODULE_PATH  ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH  ${CMAKE_PREFIX_PATH})


########## TARGETS ##########################################################################
#############################################################################################

########## COMPONENT Crypto TARGET #################################################

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    # Target approach
    if(NOT TARGET OpenSSL::Crypto)
        add_library(OpenSSL::Crypto INTERFACE IMPORTED)
        set_target_properties(OpenSSL::Crypto PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                              "${OpenSSL_Crypto_INCLUDE_DIRS}")
        set_target_properties(OpenSSL::Crypto PROPERTIES INTERFACE_LINK_DIRECTORIES
                              "${OpenSSL_Crypto_LIB_DIRS}")
        set_target_properties(OpenSSL::Crypto PROPERTIES INTERFACE_LINK_LIBRARIES
                              "${OpenSSL_Crypto_LINK_LIBS};${OpenSSL_Crypto_LINKER_FLAGS_LIST}")
        set_target_properties(OpenSSL::Crypto PROPERTIES INTERFACE_COMPILE_DEFINITIONS
                              "${OpenSSL_Crypto_COMPILE_DEFINITIONS}")
        set_target_properties(OpenSSL::Crypto PROPERTIES INTERFACE_COMPILE_OPTIONS
                              "${OpenSSL_Crypto_COMPILE_OPTIONS_C};${OpenSSL_Crypto_COMPILE_OPTIONS_CXX}")
    endif()
endif()

########## COMPONENT SSL TARGET #################################################

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    # Target approach
    if(NOT TARGET OpenSSL::SSL)
        add_library(OpenSSL::SSL INTERFACE IMPORTED)
        set_target_properties(OpenSSL::SSL PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                              "${OpenSSL_SSL_INCLUDE_DIRS}")
        set_target_properties(OpenSSL::SSL PROPERTIES INTERFACE_LINK_DIRECTORIES
                              "${OpenSSL_SSL_LIB_DIRS}")
        set_target_properties(OpenSSL::SSL PROPERTIES INTERFACE_LINK_LIBRARIES
                              "${OpenSSL_SSL_LINK_LIBS};${OpenSSL_SSL_LINKER_FLAGS_LIST}")
        set_target_properties(OpenSSL::SSL PROPERTIES INTERFACE_COMPILE_DEFINITIONS
                              "${OpenSSL_SSL_COMPILE_DEFINITIONS}")
        set_target_properties(OpenSSL::SSL PROPERTIES INTERFACE_COMPILE_OPTIONS
                              "${OpenSSL_SSL_COMPILE_OPTIONS_C};${OpenSSL_SSL_COMPILE_OPTIONS_CXX}")
    endif()
endif()

########## GLOBAL TARGET ####################################################################

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    if(NOT TARGET OpenSSL::OpenSSL)
        add_library(OpenSSL::OpenSSL INTERFACE IMPORTED)
    endif()
    set_property(TARGET OpenSSL::OpenSSL APPEND PROPERTY
                 INTERFACE_LINK_LIBRARIES "${OpenSSL_COMPONENTS}")
endif()

########## BUILD MODULES ####################################################################
#############################################################################################
########## COMPONENT Crypto BUILD MODULES ##########################################

foreach(_BUILD_MODULE_PATH ${OpenSSL_Crypto_BUILD_MODULES_PATHS})
    include(${_BUILD_MODULE_PATH})
endforeach()
########## COMPONENT SSL BUILD MODULES ##########################################

foreach(_BUILD_MODULE_PATH ${OpenSSL_SSL_BUILD_MODULES_PATHS})
    include(${_BUILD_MODULE_PATH})
endforeach()
