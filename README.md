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
Two backend frameworks can be used at once for mixed projects: one for *C* and one for *C++*. You don't *need* to use two, however:
* For C projects, a C++ framework doesn't need to be included.
* For C++ projects, a C framework doesn't need to be included.
* For mixed projects, one framework can be used for both.

<!-- TODO: Add documentation for how to use -->
