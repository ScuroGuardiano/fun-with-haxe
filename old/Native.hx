import cpp.StdString;
import cpp.Star;

@:include("./cpp/Console.cpp")
@:extern("sg::cpp::Console*")
extern class ConsoleNative {
    @:native("sg::cpp::Console::write") public static function writeNative(message: StdString): Void;
    @:native("sg::cpp::Console::writeLine") public static function writeLineNative(message: StdString): Void;
}

@:structAccess
@:unreflective
@:include("./cpp/Demon.cpp")
@:extern("Demon*")
extern class Demon {
    @:native("Demon::create") public static function create(): Demon;
    @:native("Demon::starCreate") public static function star_create(): Star<Demon>;
    @:native("Demon::destroy") public static function destroy(demon: Star<Demon>): Void;
    @:native("toString") public function to_string(): StdString;
    @:native("setAge") public function set_age(age: Int): Void;
    @:native("setName") public function set_name(name: StdString): Void;
}

@:include("./cpp/CallFunction.h")
extern class CallFunction {
    @:native("CallFunction::call") public static function call(fn: (y: Int) -> Void): Void;
}