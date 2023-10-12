cmake_minimum_required(VERSION 3.21)

# -- project setup
project(
    test-interpreter
    LANGUAGES CXX
    VERSION 0.0.0
)

# -- cmake variables
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# -- custom variables
# - executable name
set(EXEC_NAME test-interpreter)

# -- doctest
add_subdirectory(libs/doctest)
include_directories(${DOCTEST_INCLUDE_DIR})
enable_testing()

# -- compile opts
add_compile_options(-Wall -Wextra -Werror -Wpedantic)

# -- deps
# ensure that we're preferring virtual environments
set(Python_FIND_VIRTUALENV FIRST)
find_package(Python COMPONENTS Development Interpreter)
find_package(Threads REQUIRED)

# -- tests
# adds and compiles tests
add_subdirectory(tests)

# -- target
add_executable(${EXEC_NAME} src/main.cpp)
target_compile_features(${EXEC_NAME} PUBLIC cxx_std_20)
target_link_libraries(${EXEC_NAME} PUBLIC Python::Python Threads::Threads)

