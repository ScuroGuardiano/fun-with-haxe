#include <iostream>
#include <string>
    class Demon {
    private:
        int age;
        std::string name;
    
    public:
        Demon(): age(0), name("This demon has no name") {
            std::cout << "Demon created!" << std::endl;
        }
        static Demon create() {
            return Demon();
        }

        static Demon* starCreate() {
            return new Demon();
        }

        static void destroy(Demon* demon) {
            delete demon;
        }

        void setAge(int age) {
            this->age = age;
        }
        int getAge() {
            return this->age;
        }
        void setName(std::string name) {
            this->name = name;
        }
        std::string getName() {
            return this->name;
        }
        std::string toString() {
            return "Demon " + this->name + " (" + std::to_string(this->age) + ")";
        }

        ~Demon() {
            std::cout << "Demon" << this->toString() << " jest właśnie niszczony." << std::endl;
        }
    };