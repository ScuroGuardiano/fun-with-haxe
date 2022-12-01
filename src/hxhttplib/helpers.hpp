#ifndef HELPERS_H_INCLUDED
#define HELPERS_H_INCLUDED

#include "cpp-httplib.hpp"
#include <iostream>
#include <thread>

#ifndef HXCPP_H
    #include "hxcpp.h"
#endif

class HaxeCppHttplibHelpers {
public:
    inline static httplib::Server::Handler createHandler(Dynamic haxeHandler);
    inline static String cppToHaxeStr(const std::string &in);
};

inline httplib::Server::Handler HaxeCppHttplibHelpers::createHandler(::Dynamic fn) {
    std::cout << "Thread ID of Haxe: " << std::this_thread::get_id() << std::endl;
    return [=](const httplib::Request& req, httplib::Response& res) {
        int x;
        hx::SetTopOfStack(&x, false); // Attach to Haxe
        std::cout << "Thread ID for lambda: " << std::this_thread::get_id() << std::endl;
        std::cout << "Handla CPP" << std::endl;
        std::cout << "Req ptr = " << &req << ", Res ptr = " << &res << std::endl;
        ((Dynamic)fn)(cpp::Pointer<httplib::Request>(&req), cpp::Pointer<httplib::Response>(&res));
        hx::SetTopOfStack(0, false); // Detach from Haxe
    };
}

inline String HaxeCppHttplibHelpers::cppToHaxeStr(const std::string &in) {
    return String(in.c_str(), in.size()).dup();
}
#endif