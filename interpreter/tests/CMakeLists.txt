# defining executables to test

set(TEST_EXEC_NAME run_tests)

file(GLOB FILES "*.cpp")
add_executable(${TEST_EXEC_NAME} ${FILES})
target_link_libraries(${TEST_EXEC_NAME} doctest::doctest)
target_compile_features(${TEST_EXEC_NAME} PRIVATE cxx_std_20)

add_test(NAME "doctest" COMMAND ./${TEST_EXEC_NAME})

