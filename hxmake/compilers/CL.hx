package hxmake.compilers;

import hxmake.HxMake;

using hxmake.compilers.CompilerTools;
using haxe.io.Path;

class CL implements Compiler {
	public function new() {}

	public function buildObjectBinaries(hxMake:HxMake) {
        final srcPath = new haxe.io.Path(hxMake.src);
        final args = ['/c', '$srcPath'];
        for(i in hxMake.includePaths) {
            final includePath = new haxe.io.Path(i);
            if(includePath.ext == null) {
                args.push('/I$includePath');
            }
        }
        for(i in hxMake.includes) {
            final include = new haxe.io.Path(i);
            if(include.ext != null) {
                args.push('/FI$include');
            }
        }
		"cl".run(args, true);
	}

	public function buildConsumableBinaries(hxMake:HxMake) {
		final srcPath = new haxe.io.Path(hxMake.src);
		final outputPath = new haxe.io.Path(hxMake.output);
        final args = ["/LD", srcPath.file.withExtension('obj')];
        for(define in hxMake.defines) {
            args.push('/D$define');
        }
        args.concat(['/link', '/OUT:$outputPath']);
		for (_libPath in hxMake.libPaths) {
            final libPath = new haxe.io.Path(_libPath);
			if (libPath.ext == null)
				args.push('/LIBPATH:$libPath');
        }
        trace(haxe.Json.stringify(hxMake, null, "\t"));
		for (_lib in hxMake.libs) {
            
			final lib = new haxe.io.Path(_lib);
			if (lib.file != "")
				args.push(Path.join([lib.dir, lib.file.withExtension('lib')]));
        }
        // trace({args: args});
        // return;
		"cl".run(args, true);
	}
}
