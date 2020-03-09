package hxmake.compilers;

import hxmake.HxMake;

using hxmake.compilers.CompilerTools;
using haxe.io.Path;

class GCC implements Compiler {
	public function new() {}

	public function buildObjectBinaries(hxMake:HxMake) {
		final srcPath = new haxe.io.Path(hxMake.src);
		final args = ['-c', srcPath.file.withExtension(srcPath.ext), '-o'];
		args.push(srcPath.file.withExtension('obj'));
		if (hxMake.includePaths != null)
			for (i in hxMake.includePaths) {
				final includePath = new haxe.io.Path(i);
				if (includePath.ext == null) {
					args.push('-I$includePath');
				}
			}
		if (hxMake.includes != null)
			for (i in hxMake.includes) {
				final include = new haxe.io.Path(i);
				if (include.ext != null) {
					args.push('-include$include');
				}
			}
		trace('gcc ${args.join(' ')}');
		"gcc".run(args, true);
	}

	public function buildConsumableBinaries(hxMake:HxMake) {
		final srcPath = new haxe.io.Path(hxMake.src);
		final outputPath = new haxe.io.Path(hxMake.output);
		final args = ["-shared", "-o", '$outputPath', srcPath.file.withExtension('obj')];
		for (define in hxMake.defines) {
			args.push('-D $define');
		}
		args.concat(['-o', '$outputPath']);
		if (hxMake.libPaths != null)
			for (_libPath in hxMake.libPaths) {
				final libPath = new haxe.io.Path(_libPath);
				if (libPath.ext == null)
					args.push('-L$libPath');
			}
		trace(haxe.Json.stringify(hxMake, null, "\t"));
		if (hxMake.libs != null)
			for (_lib in hxMake.libs) {
				final lib = new haxe.io.Path(_lib);
				if (lib.file != "")
					args.push('-l${Path.join([lib.dir, lib.file])}');
			}
		trace('gcc ${args.join(' ')}');
		// return;
		"gcc".run(args, true);
	}
}
