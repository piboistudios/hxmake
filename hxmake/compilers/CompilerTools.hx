package hxmake.compilers;

class CompilerTools {
	public static function run(cmd:String, args:Array<String>, ?verbose:Bool):Void {
		function newProcess(c, a) {
			return new sys.io.Process(c, a).exitCode(true);
		};
		(verbose ? Sys.command : newProcess)(cmd, args);
	}
}
