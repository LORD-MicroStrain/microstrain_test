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

set(MICROSTRAIN_TEST_FRAMEWORK_C "unity" CACHE STRING)
set(MICROSTRAIN_TEST_FRAMEWORK_CPP "doctest" CACHE STRING)

FetchContent_Declare(microstrain_test
    GIT_REPOSITORY https://github.com/LORD-MicroStrain/microstrain_test.git
    GIT_TAG 0.2.0
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
Two backend frameworks can be used at once: one for *C* and one for *C++*.

<!-- TODO: Add documentation for how to use -->
