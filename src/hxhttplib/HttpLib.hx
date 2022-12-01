package hxhttplib;

import cpp.Int32;
import cpp.Function;
import cpp.vm.Gc;
import hxhttplib.HttpLibNative.NativeServer;
import hxhttplib.HttpLibNative.RequestNative;
import hxhttplib.HttpLibNative.ResponseNative;
import hxhttplib.HttpLibNative.NativeHelpers;
import cpp.StdString;
import cpp.Pointer;

typedef Handler = (req: Request, res: Response) -> Void;

class Request {
    private function new(request: Pointer<RequestNative>) {
        _request = request;
    }

    public static function create(request: Pointer<RequestNative>): Request {
        return new Request(request);
    }

    private var _request: Pointer<RequestNative>;

    public var path(get, never): String;

    function get_path(): String {
        return NativeHelpers.cppToHaxeStr(_request.value.path);
    }
}

class Response {
    private function new(response: Pointer<ResponseNative>) {
        _response = response;
    }

    public static function create(response: Pointer<ResponseNative>): Response {
        return new Response(response);
    }

    private var _response: Pointer<ResponseNative>;

    public var status(get, set): Int32;
    function get_status() return _response.value.status;
    function set_status(status: Int32) return _response.value.status = status;

    public var body(get, set): String;
    function get_body() return NativeHelpers.cppToHaxeStr(_response.value.body);
    function set_body(body: String) {
        _response.value.body = StdString.ofString(body);
        return body;
    }

    public function setHeader(key: String, val: String) {
        _response.value.set_header(StdString.ofString(key), StdString.ofString(val));
    }
}

class Server {
    private var _server: Pointer<NativeServer>;
    public function new() {
        _server = NativeServer.create();
        Gc.setFinalizer(this, Function.fromStaticFunction(finalizer));
    }

    public function get(path: String, handler: Handler) {
        _server.value.get(StdString.ofString(path), NativeHelpers.createHandler(
            (req, res) -> handler(Request.create(req), Response.create(res))
        ));
    }

    public function listen(host: String, port: Int32): Bool {
        Gc.enterGCFreeZone();
        var res = _server.value.listen(StdString.ofString(host), port);
        Gc.exitGCFreeZone();
        return res;
    }
    
    private static function finalizer(obj: Server) {
        obj._server.destroy();
    }
}