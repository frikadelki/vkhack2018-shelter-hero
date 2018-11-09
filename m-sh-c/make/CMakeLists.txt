PROJECT(hrp CXX)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

SET(PROJECT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../")
SET(PROJECT_SRC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../src")
SET(DEPS_ROOT "${PROJECT_DIR}/../m-deps-c/root/")
SET(DEPS_ROOT_INCLUDE "${DEPS_ROOT}/include/")
SET(DEPS_ROOT_LIB "${DEPS_ROOT}/lib")

# add compilation flags
SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17")

SET(EXECUTABLE_OUTPUT_PATH "${PROJECT_DIR}/target/bin/")
SET(LIBRARY_OUTPUT_PATH "${PROJECT_DIR}/target/bin/")


# include directories
SET(PROJECT_INCLUDE_DIRS
    "${PROJECT_SRC_DIR}/generated/"
    "${PROJECT_SRC_DIR}/rpc/"
    "${PROJECT_SRC_DIR}/graph/"
)

INCLUDE_DIRECTORIES(${PROJECT_INCLUDE_DIRS})
INCLUDE_DIRECTORIES(${DEPS_ROOT_INCLUDE})


# set sources
FILE(GLOB GENERATED_SOURCES
    "${PROJECT_SRC_DIR}/generated/*.cc"
    "${PROJECT_SRC_DIR}/generated/*.h"
)

FILE(GLOB RPC_SOURCES
    "${PROJECT_SRC_DIR}/rpc/*.cpp"
    "${PROJECT_SRC_DIR}/rpc/*.h"
)

FILE(GLOB GRAPH_SOURCES
    "${PROJECT_SRC_DIR}/graph/*.cpp"
    "${PROJECT_SRC_DIR}/graph/*.h"
)


link_directories(${DEPS_ROOT_LIB})

# define targets
add_library(hrplib STATIC
    ${GENERATED_SOURCES}
    ${RPC_SOURCES}
    ${GRAPH_SOURCES}
)

target_link_libraries(hrplib
    -Wl,-Bstatic
        -lgrpc++
        -lgrpc
        -lprotobuf
    -Wl,-Bdynamic
        -lpthread
        -lz
)

add_executable(hrp
    ${PROJECT_SRC_DIR}/MainRouting.cpp
)

add_dependencies(hrp hrplib)
target_link_libraries(hrp hrplib)

add_executable(tojson
    ${PROJECT_SRC_DIR}/MainJson.cpp
)

add_dependencies(tojson hrplib)
target_link_libraries(tojson hrplib)
