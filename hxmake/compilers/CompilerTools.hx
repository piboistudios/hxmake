package hxmake.compilers;

class CompilerTools {
    public static function run(cmd:String, args:Array<String>, ?verbose:Bool):Void {
        function newProcess(c, a) {
            new sys.io.Process(c, a);
            return 0;
        };
        (
            verbose ? Sys.command : newProcess
        )
            (cmd, args);

    }
}