package hxmake.compilers;
import haxe.io.Path;

class CompilerBase {
    public var cmd:String;
    var hxMake:hxmake.HxMake;

    public var outputPath(get, never):Path;
    public function get_outputPath() {
        return this.hxMake.outputPath;
    }
    public var srcPath(get, never):Path;
    public function get_srcPath() {
        return this.hxMake.srcPath;
    }
    public function new(hxMakefile:hxmake.HxMake) {
        this.hxMake = hxMakefile;
    }
}