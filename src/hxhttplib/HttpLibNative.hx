package hxhttplib;

import cpp.Pointer;
import cpp.Star;
import cpp.StdString;
import cpp.Reference;
import cpp.Int32;

@:include("./cpp-httplib.hpp")
@:unreflective
@:native("httplib::Server::Handler")
extern class NativeHandler {}

@:include("./cpp-httplib.hpp")
@:structAccess
@:unreflective
@:native("httplib::Server")
extern class NativeServer {
    @:native("Get")
    public function get(pattern: Reference<StdString>, handler: NativeHandler): Reference<NativeServer>; 
    
    public function listen(host: Reference<StdString>, port: Int32): Bool;
    
    @:native("new httplib::Server")
    public static function create(): Pointer<NativeServer>;
}

@:include("./cpp-httplib.hpp")
@:unreflective
@:structAccess
@:native("httplib::Request")
extern class RequestNative {
    public var path: StdString;
}

@:include("./cpp-httplib.hpp")
@:unreflective
@:structAccess
@:native("httplib::Response")
extern class ResponseNative {
    public var status: Int32;
    public var body: StdString;

    @:native("set_header")
    public function set_header(key: StdString, val: StdString): Void;
}

@:include("./helpers.hpp")
@:native("HaxeCppHttplibHelpers")
extern class NativeHelpers {
    @:native("HaxeCppHttplibHelpers::createHandler")
    public static function createHandler(handler: (Pointer<RequestNative>, Pointer<ResponseNative>) -> Void): NativeHandler;

    @:native("HaxeCppHttplibHelpers::cppToHaxeStr")
    public static function cppToHaxeStr(input: Reference<StdString>): String;
}