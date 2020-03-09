package hxmake.compilers;
import hxmake.HxMake;
using hxmake.compilers.CompilerTools;
using haxe.io.Path;
class GCC implements  Compiler {
    public function new() {}
    public   function run(hxMake:HxMake) {
        final srcPath = new haxe.io.Path(hxMake.src);
        "gcc".run(['-c', srcPath.file.withExtension(srcPath.ext), '-o', srcPath.file.withExtension('obj')], true);
    }
}