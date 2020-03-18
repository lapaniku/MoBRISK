cmake_minimum_required (VERSION 2.8)
set(CMAKE_BUILD_TYPE Debug)

set(CMAKE_C_COMPILER /usr/bin/gcc)
set(CMAKE_CXX_COMPILER /usr/bin/g++)
add_definitions(-std=c++14 -Werror -g -fopenmp)

OPTION (USE_OpenMP "Use OpenMP" ON)
IF(USE_OpenMP)
  FIND_PACKAGE(OpenMP)
  IF(OPENMP_FOUND)
    SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS}")
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
  ENDIF()
ENDIF()


find_package(OpenCV REQUIRED)
find_package(Boost REQUIRED COMPONENTS filesystem system)

include_directories(include)
include_directories(${OpenCV_INCLUDE_DIRS})

include_directories(${PROJECT_SOURCE_DIR}/brisk/include)
include_directories(${PROJECT_SOURCE_DIR}/brisk/agast/include)

SET(SRC_PATH ${CMAKE_CURRENT_SOURCE_DIR}/src/)
file(GLOB_RECURSE EXECS RELATIVE ${CMAKE_SOURCE_DIR} "src/*.cc")
file(GLOB_RECURSE SOURCES RELATIVE ${CMAKE_SOURCE_DIR} "src/*.cc")
file(GLOB_RECURSE SOURCES RELATIVE ${CMAKE_SOURCE_DIR} "src/*.cpp")

SET(OpenCV_LIBS opencv_core opencv_highgui opencv_imgproc opencv_ximgproc opencv_objdetect opencv_video)

SET(EXECS ${SRC_PATH}/main.cpp)

foreach(exec_src ${EXECS})
    get_filename_component(exec_name ${exec_src} NAME_WE)
    add_executable(${exec_name} ${exec_src} ${SOURCES})
    target_link_libraries(${exec_name} ${OpenCV_LIBS} ${Boost_LIBRARIES})
endforeach()
