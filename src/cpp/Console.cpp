#include <iostream>
#include <string>

namespace sg::cpp {
    class Console {
    public:
        static void write(std::string message) {
            std::cout << message;
        }
        static void writeLine(std::string message) {
            std::cout << message << std::endl;
        }
    };
}
