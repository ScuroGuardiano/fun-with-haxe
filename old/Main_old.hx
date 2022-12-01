import Native.CallFunction;
import cpp.Function;
import cpp.Callable;
import cpp.vm.Gc;
import Native.Demon;
import Native.ConsoleNative;
import cpp.StdString;
import cpp.Stdio;
import cpp.Star;

class Console {
    public static function write(message: String) {
        ConsoleNative.writeNative(StdString.ofString(message));
    }
    public static function writeLine(message: String) {
        ConsoleNative.writeLineNative(StdString.ofString(message));
    }
}

class DemonWrapper {
    public function new(age: Int, name: String) {
        _demon = Demon.star_create();
        _demon.set_name(StdString.ofString(name));
        _demon.set_age(age);

        Gc.setFinalizer(this, Function.fromStaticFunction(DemonWrapper.finalize));
    }
    private var _demon: Star<Demon>;
    public function getDemon(): Star<Demon> {
        return _demon;
    }
    public static function finalize(instance: DemonWrapper) {
        Console.writeLine("@@@@@FINALIZER");
        Demon.destroy(instance.getDemon());
    }
}

class Main {
    static private function createDemon(age: Int, name: String): Demon {
        var demon = Demon.create();
        demon.set_age(age);
        demon.set_name(StdString.ofString(name));
        return demon;
    }

    static private function printDemon(demon: Demon): Void {
        ConsoleNative.writeLineNative(demon.to_string());
    }
    static private function printStarDemon(demon: Star<Demon>) {
        ConsoleNative.writeLineNative(demon.to_string());
    }

    static private function memLeak() {
        var demon: DemonWrapper = new DemonWrapper(16, "Lucifer");
    }

    static public function main():Void {
        // while(true) {
        //     memLeak();
        // }
        // Gc.run(true);

        var x = 5;
        var func = (y: Int) -> {
            Console.writeLine('$x + $y = ${x + y}');
        }
        callFn(func);
        CallFunction.call(func);
    }

    static public function callFn(fn: (y: Int) -> Void) {
        fn(6);
    }
}