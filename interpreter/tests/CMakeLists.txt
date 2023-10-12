# defining executables to test

file(GLOB FILES "*.cpp")
add_executable(tests ${FILES})
target_link_libraries(tests doctest::doctest)
target_compile_features(tests PRIVATE cxx_std_20)

add_test(NAME "doctest" COMMAND ./tests)

