# Copyright (C) 2019 Intel Corporation.  All rights reserved.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

set (LIBC_WASI_DIR ${CMAKE_CURRENT_LIST_DIR})
set (UVWASI_DIR ${CMAKE_CURRENT_LIST_DIR}/../../../deps/uvwasi)
set (LIBUV_VERSION v1.42.0)

add_definitions (-DWASM_ENABLE_LIBC_WASI=1 -DWASM_ENABLE_UVWASI=1)

include(FetchContent)
## https://libuv.org
FetchContent_Declare(
    libuv
    GIT_REPOSITORY https://github.com/libuv/libuv.git
    GIT_TAG ${LIBUV_VERSION})

FetchContent_GetProperties(libuv)
if(NOT libuv_POPULATED)
    message ("-- Fetching libuv ..")
    FetchContent_Populate(libuv)
    include_directories("${libuv_SOURCE_DIR}/include")
    add_subdirectory(${libuv_SOURCE_DIR} ${libuv_BINARY_DIR} EXCLUDE_FROM_ALL)
    set (UV_A_LIBS uv_a)
    set_target_properties(uv_a PROPERTIES POSITION_INDEPENDENT_CODE 1)
endif()

include_directories(${UVWASI_DIR}/include)

file (GLOB_RECURSE source_all ${LIBC_WASI_DIR}/*.c ${UVWASI_DIR}/src/*.c)

set (LIBC_WASI_SOURCE ${source_all})
