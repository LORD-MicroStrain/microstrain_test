# Microstrain Test
A lightweight meta-framework for automated testing with CMake and CTest. 

## Objectives
* Provide a common interface for test registration and discovery.
* Share custom assertions and utilities between test frameworks.
* Make it easy to install test frameworks.

## Setup
### Install
Add the following to your CMakeLists.txt file:
```
include(FetchContent)

set(MICROSTRAIN_TEST_FRAMEWORK_C "unity" CACHE STRING "" FORCE)
set(MICROSTRAIN_TEST_FRAMEWORK_CPP "doctest" CACHE STRING "" FORCE)

FetchContent_Declare(microstrain_test
    GIT_REPOSITORY https://github.com/LORD-MicroStrain/microstrain_test.git
    GIT_TAG 0.2.4
)

FetchContent_MakeAvailable(microstrain_test)
```
Replace the frameworks and version git tag to what you would like to use.

### Supported frameworks
| Language | Framework                                        | Value to use |
|----------|--------------------------------------------------|--------------|
| C        | [Unity](https://github.com/ThrowTheSwitch/Unity) | `"unity"`    |
| C++      | [Doctest](https://github.com/doctest/doctest)    | `"doctest"`  |

## How to use
### Framework backends
Two backend frameworks can be used at once for mixed projects: one for *C* and one for *C++*. You don't *need* to use two, however:
* For C projects, a C++ framework doesn't need to be included.
* For C++ projects, a C framework doesn't need to be included.
* For mixed projects, one framework can be used for both.

To use a framework interface, include the respecting header in each test file:

| Language | Header                                  |
|----------|-----------------------------------------| 
| C        | `microstrain_test/microstrain_test.h`   |
| C++      | `microstrain_test/microstrain_test.hpp` |


#### Example using the C interface
<!-- The rendering engine doesn't seem to recognize "C" -->
```c++
#include <microstrain_test/microstrain_test.h>

MICROSTRAIN_TEST_CASE(a_test_suite, a_test_case)
{
    // Test case code...
}
```

#### Example using the C++ interface
```c++
#include <microstrain_test/microstrain_test.hpp>

MICROSTRAIN_TEST_CASE(a_test_suite, a_test_case)
{
    // Test case code...
}
```
### Assertions and backend framework features
* All assertions and features of the backend framework(s) can be used directly within each test case registration (definition).
* The framework backend is included automatically.
* Custom assertions can be used seamlessly alongside those from the backend framework(s).

### Discovering tests to run
MicrostrainTest supports two methods for discovering tests: *Manual* and *Automatic*.

#### Automatic
This is the preferred method. Tests simply need to be registered (defined) in test files, and then will be automatically discovered and run by CTest.

To set up automatic test discovery, add the following to your CMakeLists.txt file
```cmake
# Add executables for running tests
add_executable(test_runner_c
    # Test file sources...
)
add_executable(test_runner_cpp
    # Test file sources...
)

# Link all required dependencies for the executables
target_link_libraries(test_runner_c PRIVATE
    # Dependencies...
    microstrain_test::c
)
target_link_libraries(test_runner_cpp PRIVATE
    # Dependencies...
    microstrain_test::cpp
)

# Include the discovery script
include(${microstrain_test_SOURCE_DIR}/scripts/DiscoverTests.cmake)

# Automatically discover and register tests with CTest
microstrain_discover_tests_c(
    TARGET test_runner_c
    LABELS "C Tests!!!"
)
microstrain_discover_tests_cpp(
    TARGET test_runner_cpp
    LABELS "C++ Tests!!!"
)
```

The `LABELS` argument allows you to specify additional labels for filtering tests with CTest.

Additionally, there are two modes to run tests in an executable: *sequential* and *parallel*. 

| Mode       | Description                                                                                                                                                                                 |
|------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Parallel   | The default mode, it will run all tests in the executable in parallel (if CTest is run with `-j`).                                                                                          |
| Sequential | When explicitly set, it will run the tests in each test file in order, one at a time. If CTest is **not** run with `-j`, then all tests in the executable will run in order, one at a time. |

To set the mode to *sequential*, add the following argument to the test discovery function:
```cmake
microstrain_discover_tests_c(
    TARGET test_runner_c
    LABELS "C Tests running sequentially!!!"
    SEQUENTIAL
)
microstrain_discover_tests_cpp(
    TARGET test_runner_cpp
    LABELS "C++ Tests running sequentially!!!"
    SEQUENTIAL
)
```

#### Manual
To manually discover tests, add a main function for each test file:
```c++
MICROSTRAIN_TEST_DEFAULT_SETUP();

// Test registration (definition) code...

int main()
{
    MICROSTRAIN_TEST_BEGIN();
    
    RUN_MICROSTRAIN_TEST_CASE(suite1, test1);
    RUN_MICROSTRAIN_TEST_CASE(suite1, test2);
    
    RUN_MICROSTRAIN_TEST_CASE(suite2, test1);
    RUN_MICROSTRAIN_TEST_CASE(suite2, test2);
    
    // Add test run calls for all other tests in the file...
    
    return MICROSTRAIN_TEST_END();
}
```

Then register a CTest test for each test.
