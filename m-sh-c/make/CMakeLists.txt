PROJECT(shrecomm CXX)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

SET(PROJECT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../")
SET(PROJECT_SRC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../src")
SET(DEPS_ROOT "${PROJECT_DIR}/../m-deps-c/root/")
SET(DEPS_ROOT_INCLUDE "${DEPS_ROOT}/include/")
SET(DEPS_ROOT_LIB "${DEPS_ROOT}/lib")

# add compilation flags
SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17 -Wall")

SET(EXECUTABLE_OUTPUT_PATH "${PROJECT_DIR}/target/bin/")
SET(LIBRARY_OUTPUT_PATH "${PROJECT_DIR}/target/bin/")


# include directories
SET(PROJECT_INCLUDE_DIRS
    "${PROJECT_SRC_DIR}/generated/"
    "${PROJECT_SRC_DIR}/rpc/"
    "${PROJECT_SRC_DIR}/recommendations/"
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

FILE(GLOB RECOMM_SOURCES
    "${PROJECT_SRC_DIR}/recommendations/*.cpp"
    "${PROJECT_SRC_DIR}/recommendations/*.h"
)


link_directories(${DEPS_ROOT_LIB})

# define targets
add_library(shlib STATIC
    ${GENERATED_SOURCES}
    ${RPC_SOURCES}
    ${RECOMM_SOURCES}
)

target_link_libraries(shlib
    -Wl,-Bstatic
        -lgrpc++
        -lgrpc++_unsecure
        -lgrpc_unsecure
        -lgrpc
        -lprotobuf
    -Wl,-Bdynamic
        -lpthread
        -lz
)

add_executable(shrecomm
    ${PROJECT_SRC_DIR}/MainRecommendations.cpp
)
add_dependencies(shrecomm shlib)
target_link_libraries(shrecomm shlib)

add_executable(shtests
    ${PROJECT_SRC_DIR}/MainTests.cpp
)
add_dependencies(shtests shlib)
target_link_libraries(shtests shlib)
