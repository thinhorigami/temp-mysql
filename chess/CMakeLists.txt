
find_package(MySQL REQUIRED)

add_executable(chess "chess.cpp")

target_sources(chess
  PRIVATE
#   sources/header files  
)

# target_link_directories(chess PRIVATE ${CONAN_LIB_DIRS_LIBMYSQLCLIENT})
target_include_directories(chess PRIVATE ${MYSQL_INCLUDE_DIR})
target_link_libraries(chess PRIVATE ${MySQL_LIBRARIES})