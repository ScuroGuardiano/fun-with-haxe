import hxhttplib.HttpLib.Server;
import haxe.ds.List;
import haxe.Int64;
import sys.thread.Thread;

class RandomObjectToFuckGCHardInItsAss {
    public function new(number: Int64, string: String) {
        this.number = number;
        this.string = string;
    }

    var number: Int64;
    var string: String;
}

class Main {
    static public function runGcStress() {
        Thread.create(() -> {
            // GC Stresser
            trace("Thread started!");
            var i: Int64 = 0;
            var list = new List<RandomObjectToFuckGCHardInItsAss>();
            while(true) {
                var x = new RandomObjectToFuckGCHardInItsAss(i++, "Oh look at this memory mess!");
                list.add(x);
                if (i % 100000 == 0) {
                    // trace(Gc.memInfo(Gc.MEM_INFO_USAGE));
                    // trace('Elements in list: ${list.length}.');
                    // trace("Removing reference to it.");
                    list = new List<RandomObjectToFuckGCHardInItsAss>();
                }
            }
            trace("Thread ended!");
        });
    }

    static public function main():Void {
        var http = new Server();
        http.get(".*", (req, res) -> {
            res.status = 200;
            res.setHeader("Content-Type", "application/json");
            res.body = '{"message": "Hello, world!", "path": "${req.path}"}';
        });

        http.listen("0.0.0.0", 1337);
    }
}