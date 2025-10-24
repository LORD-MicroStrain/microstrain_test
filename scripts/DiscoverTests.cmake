include(${microstrain_test_SOURCE_DIR}/scripts/internal/Internals.cmake)

# Automatically discovers and sets tests to run (C framework API).
#
# Arguments:
#     TARGET - An executable with the source files for all tests to run linked to it.
#              A main function will be generated for this executable to run the tests.
#     LABELS - Additional CTest labels for the tests discovered. Example use cases:
#              "unit" or "integration" to allow all tests of each type to be run.
#     SEQUENTIAL - A boolean switch to run all tests discovered one at a time, instead
#                  of in parallel. If this isn't passed, the tests will run in parallel.
function(microstrain_discover_tests_c)
    # Set policy to allow for test names with special characters
    if(POLICY CMP0110)
        cmake_policy(SET CMP0110 NEW)
    endif()

    cmake_parse_arguments(
        ARG
        "SEQUENTIAL"
        "TARGET"
        "LABELS"
        ${ARGN}
    )

    # Verify the target exists
    if(NOT TARGET ${ARG_TARGET})
        message(FATAL_ERROR "Target ${ARG_TARGET} does not exist")
        return()
    endif()

    # Verify the target has source files set
    get_target_property(TARGET_SOURCES ${ARG_TARGET} SOURCES)
    if(NOT TARGET_SOURCES OR TARGET_SOURCES STREQUAL "TARGET_SOURCES-NOTFOUND")
        internal_generate_test_runner_file_with_dummy_main("${ARG_TARGET}")
        return()
    endif()

    internal_parse_test_registrations_from_sources(
        "${TARGET_SOURCES}"
        DISCOVERED_SUITES
        DISCOVERED_TESTS
        TEST_FILEPATHS
    )

    # Exit early if no test registrations are found
    if(NOT DISCOVERED_SUITES OR NOT DISCOVERED_TESTS)
        internal_generate_test_runner_file_with_dummy_main("${ARG_TARGET}")
        return()
    endif()

    internal_generate_test_runner_file_with_main(
        "${ARG_TARGET}"
        "${DISCOVERED_SUITES}"
        "${DISCOVERED_TESTS}"
        "${TEST_FILEPATHS}"
        GENERATED_MAIN
    )

    # Add generated main to existing executable
    target_sources(${ARG_TARGET} PRIVATE ${GENERATED_MAIN})

    internal_register_individual_tests_with_ctest(
        "${ARG_TARGET}"
        "${DISCOVERED_SUITES}"
        "${DISCOVERED_TESTS}"
        "${ARG_LABELS}"
        "${ARG_DISABLED}"
        "${ARG_SEQUENTIAL}"
    )
endfunction()


# Automatically discovers and sets tests to run (C++ framework API).
#
# Arguments:
#     TARGET - An executable with the source files for all tests to run linked to it.
#              A main function will be generated for this executable to run the tests.
#     LABELS - Additional CTest labels for the tests discovered. Example use cases:
#              "unit" or "integration" to allow all tests of each type to be run.
#     SEQUENTIAL - A boolean switch to run all tests discovered one at a time, instead
#                  of in parallel. If this isn't passed, the tests will run in parallel.
function(microstrain_discover_tests_cpp)
    cmake_parse_arguments(
        ARG
        "SEQUENTIAL"
        "TARGET"
        "LABELS"
        ${ARGN}
    )

    if(MICROSTRAIN_TEST_FRAMEWORK_CPP STREQUAL "doctest")
        include(${doctest_SOURCE_DIR}/scripts/cmake/doctest.cmake)

        if(ARG_SEQUENTIAL)
            doctest_discover_tests(
                ${ARG_TARGET}
                PROPERTIES
                    LABELS ${ARG_LABELS}
                    RESOURCE_LOCK ${ARG_TARGET}
            )
        else()
            doctest_discover_tests(
                ${ARG_TARGET}
                PROPERTIES
                    LABELS ${ARG_LABELS}
            )
        endif()
    endif()
endfunction()
