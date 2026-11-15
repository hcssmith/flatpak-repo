# Minimal replacement for LuaDist's CMakeLists.txt (their cmake/
# framework targets CMake 2.8 and won't configure under the SDK's
# CMake 4; same approach as the lpeg module).
cmake_minimum_required(VERSION 3.16)
project(lsqlite3 C)

find_package(PkgConfig REQUIRED)
pkg_check_modules(SQLITE3 REQUIRED IMPORTED_TARGET sqlite3)

# Lua 5.1 C module for the app's luajit (headers come in via
# CMAKE_C_FLAGS, as with lpeg). require("lsqlite3") wants
# lsqlite3.so, so drop the default "lib" prefix.
add_library(lsqlite3 MODULE lsqlite3.c)
set_target_properties(lsqlite3 PROPERTIES PREFIX "")
target_link_libraries(lsqlite3 PRIVATE PkgConfig::SQLITE3)

install(TARGETS lsqlite3 DESTINATION lib/lua/5.1)
