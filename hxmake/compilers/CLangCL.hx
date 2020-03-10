package hxmake.compilers;

import hxmake.HxMake;

using hxmake.compilers.CompilerTools;
using haxe.io.Path;

class CLangCL extends CL {
	public function new(h) {
		super(h);
		this.cmd = 'clang-cl';
	}
}
