#ifndef HXCPP_H
    #include "hxcpp.h"
#endif


class CallFunction {
public:
    static void call(::Dynamic fn) {
        [=](){
            ((Dynamic)fn)(5);
        }();
    }
};