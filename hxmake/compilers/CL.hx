package hxmake.compilers;

import hxmake.HxMake;

using hxmake.compilers.CompilerTools;
using haxe.io.Path;

class CL extends CompilerBase implements Compiler {
	public function new(h) {
        super(h);
        this.cmd = 'cl';
    }

	public function getSrcCompilationOptions() {
		return ['/nologo', '/c', srcPath.toString()];
	}

	public function getIncludePathOption(includePath:Path) {
		return ['/I$includePath'];
	}

	public function getIncludeOption(include:Path) {
		return ['/FI$include'];
	}

	public function getBinaryCompilationOptions() {
		return ['/LD', Path.join([outputPath.dir, outputPath.file.withExtension('obj')])];
	}

	public function getDefineOption(define) {
		return ['/D$define'];
	}

	public function getOutputOptions() {
		return ['/link', '/OUT:$outputPath'];
	}

	public function getLibPathIncludeOption(libPath:Path) {
		return ['/LIBPATH:$libPath'];
	}

	public function getLibOption(lib:Path) {
		return [Path.join([lib.dir, lib.file.withExtension('lib')])];
	}
}
