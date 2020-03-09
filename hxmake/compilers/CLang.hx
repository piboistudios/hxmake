package hxmake.compilers;

import hxmake.HxMake;

using hxmake.compilers.CompilerTools;
using haxe.io.Path;

class CLang extends GCC {
	public function new(h) {
        super(h);
        this.cmd = 'clang';
    }

}
