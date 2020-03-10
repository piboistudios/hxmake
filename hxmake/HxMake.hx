package hxmake;

import haxe.macro.Expr;
import haxe.io.Path;
import tink.cli.*;

using hxmake.compilers.CompilerTools;
using Lambda;

@:alias(false)
class HxMake {
	static function readHxMake() {
		return ~/(\s|$)/gi.split(sys.io.File.getContent(Sys.args()[0])).filter(s -> s.length != 0);
	}

	#if !hxnodejs
	public static function main(?a:Array<String>) {
		final args = a != null ? a : Sys.args();
		if (args.length == 0) {
			trace('No HxMakefile provided. Command usage: `hxmake <hxMakefile>');
			Sys.exit(1);
		}
		final compiler = args[1];
		final verbose = args.has('verbose') || args.has('v') || args.has('-verbose') || args.has('-v');
		tink.Cli.process(readHxMake(), new HxMake(compiler, verbose)).handle(tink.Cli.exit);
	}
	#end

	public function new(compiler = null, verbose = false) {
		this.compilerName = compiler;
		this.verbose = verbose;
	}

	var compilerName:String;

	@:flag('-lib')
	public var libs:Array<String> = null;
	@:flag('-lib-path')
	public var libPaths:Array<String> = null;
	@:flag('-src')
	public var src:String;
	// @:flag('-include-path')
	@:flag('-include-path')
	public var includePaths:Array<String> = null;
	@:flag('-include-header')
	public var includes:Array<String> = null;
	// public var includes:Array<String> = null;
	@:flag('-o')
	public var output:String;
	@:flag('-D')
	public var defines:Array<String> = null;
	@:flag('-win-api')
	public var winApi:Null<Bool> = null;

	var verbose:Bool;
	var compiler:hxmake.compilers.Compiler;

	function getCompiler(compilerName):hxmake.compilers.Compiler {
		return switch compilerName {
			case 'gcc': new hxmake.compilers.GCC(this);
			case 'cl': new hxmake.compilers.CL(this);
			case "cc" | "clang": new hxmake.compilers.CLang(this);
			case compiler:
				#if eval
				haxe.macro.Context.fatalError('HxMake: Compiler not found: $compiler. Aborting',
					haxe.macro.Context.makePosition({file: 'hxmake.hx', max: 0, min: 0}));
				throw 'abort';
				#else
				new hxmake.compilers.GCC(this);
				#end
		};
	}

	@:defaultCommand
	public function run(rest:Rest<String>) {
		// trace(rest);
		this.compiler = this.compilerName != null && this.compilerName.length != 0 ? getCompiler(this.compilerName) : #if eval if (haxe.macro.Context.defined('hxmake-compiler')) getCompiler(haxe.macro.Context.definedValue('hxmake-compiler')); else getCompiler('gcc'); #else getCompiler('gcc'); #end#if eval
		if (haxe.macro.Context.defined('hxmake-verbose'))
			verbose = true;
		#end
		buildObjectBinaries();
		buildFinalBinaries();
		// cmd('cl', getGCCArgs(rest));
	}

	var _srcPath:Path;

	@:flag(false)
	public var srcPath(get, never):Path;

	public function get_srcPath() {
		if (_srcPath == null)
			_srcPath = new haxe.io.Path(src);
		return _srcPath;
	}

	var _outputPath:Path;

	@:flag(false)
	public var outputPath(get, never):Path;

	public function get_outputPath() {
		if (_outputPath == null)
			_outputPath = new haxe.io.Path(output);
		return _outputPath;
	}

	function buildObjectBinaries() {
		var args = compiler.getSrcCompilationOptions();
		if (includePaths != null)
			for (i in includePaths) {
				final includePath = new haxe.io.Path(i);
				if (includePath.ext == null) {
					args = args.concat(compiler.getIncludePathOption(includePath));
				}
			}
		if (includes != null)
			for (i in includes) {
				final include = new haxe.io.Path(i);
				if (include.ext != null) {
					args = args.concat(compiler.getIncludeOption(include));
				}
			}
		trace('running cmd: ${compiler.cmd} ${args.join(' ')}');
		compiler.cmd.run(args, verbose);
	}

	function buildFinalBinaries() {
		var args = compiler.getBinaryCompilationOptions();
		if (defines != null)
			for (define in defines)
				args = args.concat(compiler.getDefineOption(define));
		args = args.concat(compiler.getOutputOptions());
		if (libPaths != null)
			for (libPath in libPaths) {
				final libPath = new haxe.io.Path(libPath);
				if (libPath.ext == null)
					args = args.concat(compiler.getLibPathIncludeOption(libPath));
			}
		if (libs != null)
			for (_lib in libs) {
				final lib = new haxe.io.Path(_lib);
				if (lib.file != "")
					args = args.concat(compiler.getLibOption(lib));
			}
		trace('running cmd: ${compiler.cmd} ${args.join(' ')}');
		compiler.cmd.run(args, verbose);
	}
}
