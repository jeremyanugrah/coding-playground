#include <iostream>
#include <string>
#include <vector>

int main() {
  std::vector<std::string> fruits = {"Apple", "Banana", "Cherry"};
  int counter = 0;

  for (const auto &fruit : fruits) {
    counter++;
    std::cout << "Processing: " << fruit << std::endl; // SET BREAKPOINT HERE
  }

  std::cout << "Total fruits processed: " << counter << std::endl;
  return 0;
}
