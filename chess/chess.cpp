#include <iostream>
#include <mysql.h>
// using namespace std;

int main(void) {
  
  std::cout << "MySQL client version: " <<  mysql_get_client_info() << "\n";

  return 0;
}