package hxmake.compilers;

import hxmake.HxMake;

using hxmake.compilers.CompilerTools;
using haxe.io.Path;

class GCC extends CompilerBase implements Compiler {
	public function new(h) {
		super(h);
		this.cmd = 'gcc';
	}

	public function getSrcCompilationOptions() {
		return ['-c', srcPath.toString(), '-o', Path.join([outputPath.dir, outputPath.file.withExtension('obj')])];
	}

	public function getIncludePathOption(includePath:Path) {
		return ['-I', '$includePath'];
	}

	public function getIncludeOption(include:Path) {
		return ['-include', '$include'];
	}

	public function getBinaryCompilationOptions() {
		final ret = [];
		if(hxMake.winApi) ret.push("-mwindows");
		return ret.concat(["-shared", "-o", '$outputPath', Path.join([outputPath.dir, outputPath.file.withExtension('obj')])]);
	}

	public function getDefineOption(define) {
		return ['-D', '$define'];
	}

	public function getOutputOptions() {
		return ['-o', '$outputPath'];
	}

	public function getLibPathIncludeOption(libPath:Path) {
		return ['-L$libPath'];
	}

	public function getLibOption(lib:Path) {
		return ['-l${Path.join([lib.dir, lib.file])}'];
	}


}
