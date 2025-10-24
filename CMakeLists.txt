cmake_minimum_required(VERSION 3.19)
project(microstrain_test
    VERSION 0.1.0
)

# ---------------------------------------------------------------
# Framework backends
# ---------------------------------------------------------------

set(SUPPORTED_FRAMEWORKS_C
    "unity"
)
set(SUPPORTED_FRAMEWORKS_CPP
    "doctest"
)

# These should be set before installing in an external project
set(MICROSTRAIN_TEST_FRAMEWORK_C "" CACHE STRING "Backend framework for C")
set(MICROSTRAIN_TEST_FRAMEWORK_CPP "" CACHE STRING "Backend framework for C++")

if(MICROSTRAIN_TEST_FRAMEWORK_C AND NOT MICROSTRAIN_TEST_FRAMEWORK_C IN_LIST SUPPORTED_FRAMEWORKS_C)
    message(FATAL_ERROR "Backend not supported for C! Supported backends are: ${SUPPORTED_FRAMEWORKS_C}")
endif()

if(MICROSTRAIN_TEST_FRAMEWORK_CPP AND NOT MICROSTRAIN_TEST_FRAMEWORK_CPP IN_LIST SUPPORTED_FRAMEWORKS_CPP)
    message(FATAL_ERROR "Backend not supported for C++! Supported backends are: ${SUPPORTED_FRAMEWORKS_CPP}")
endif()

# ---------------------------------------------------------------
# Framework setup
# ---------------------------------------------------------------

add_library(microstrain_test_c INTERFACE)
add_library(microstrain_test_cpp INTERFACE)

set_target_properties(microstrain_test_c PROPERTIES
    VERSION ${PROJECT_VERSION}
    SOVERSION ${PROJECT_VERSION_MAJOR}
    LINKER_LANGUAGE C
)
set_target_properties(microstrain_test_cpp PROPERTIES
    VERSION ${PROJECT_VERSION}
    SOVERSION ${PROJECT_VERSION_MAJOR}
    LINKER_LANGUAGE CXX
)

target_include_directories(microstrain_test_c INTERFACE
    "${CMAKE_CURRENT_LIST_DIR}"
)
target_include_directories(microstrain_test_cpp INTERFACE
    "${CMAKE_CURRENT_LIST_DIR}"
)

target_sources(microstrain_test_c INTERFACE
    "microstrain_test/microstrain_test.h"
)
target_sources(microstrain_test_cpp INTERFACE
    "microstrain_test/microstrain_test.hpp"
)

# Add namespace aliases
add_library(microstrain_test::c ALIAS microstrain_test_c)
add_library(microstrain_test::cpp ALIAS microstrain_test_cpp)

if(MSVC)
    set(COMPILE_OPTIONS
        "/W4" # Enable warnings
        "/WX" # Warnings as errors
        "/MP" # Multi-process compilation
    )
else()
    set(COMPILE_OPTIONS
        "-Wall"   # Enable warnings
        "-Wextra" # Enable extra warnings
        "-Werror" # Warnings as errors
    )
endif()

target_compile_options(microstrain_test_c INTERFACE
    "${COMPILE_OPTIONS}"
)
target_compile_options(microstrain_test_cpp INTERFACE
    "${COMPILE_OPTIONS}"
)

# ---------------------------------------------------------------
# (C) Unity setup
# ---------------------------------------------------------------

if(MICROSTRAIN_TEST_FRAMEWORK_C STREQUAL "unity")
    include(scripts/internal/InstallUnity.cmake)

    target_compile_definitions(microstrain_test_c INTERFACE
        "MICROSTRAIN_TEST_USE_UNITY"
    )

    target_link_libraries(microstrain_test_c INTERFACE
        unity
    )
endif()

# ---------------------------------------------------------------
# (C++) Doctest setup
# ---------------------------------------------------------------

if(MICROSTRAIN_TEST_FRAMEWORK_CPP STREQUAL "doctest")
    include(scripts/internal/InstallDoctest.cmake)

    target_compile_definitions(microstrain_test_cpp INTERFACE
        "MICROSTRAIN_TEST_USE_DOCTEST"
    )

    target_link_libraries(microstrain_test_cpp INTERFACE
        doctest_with_main
    )
endif()
