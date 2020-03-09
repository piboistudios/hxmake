import tink.testrunner.*;
import tink.unit.*;
import tink.unit.Assert.assert;
import hxmake.compilers.*;
import sys.FileSystem;
import tink.cli.*;
import tink.Cli;
import hxmake.*;

using tink.CoreApi;
using Lambda;

class RunTests {
	static function main() {
		Runner.run(TestBatch.make([new Test()])).handle(Runner.exit);
	}
}

class Test {
	var hxMake:Array<String>;
	var asserts:AssertionBuffer = new AssertionBuffer();

	public function new() {
		this.hxMake = readHxMake();
	}

	function readHxMake() {
		return ~/(\s|$)/gi.split(sys.io.File.getContent("./HxMakefile.test")).filter(s -> s.length != 0);
	}

	function exists(file) {
		return sys.FileSystem.exists(file);
	}

	function delete(file) {
		trace('$file found! Deleting');
		Sys.sleep(0.5);
		sys.FileSystem.deleteFile(file);
	}
	// public function test_clang() {
	// 	Cli.process(hxMake, new HxMake('clang')).handle(() -> {
	// 		asserts.assert(['odbc.dll', 'odbc.obj'].foreach(file -> {
	// 			final retVal = exists(file);
	// 			if (retVal)
	// 				delete(file);
	// 			return retVal;
	// 		}));
	// 		asserts.done();
	// 	});
	// 	return assert(true);
	// }

	public function test_cl() {
		Cli.process(hxMake, new HxMake('cl')).handle(() -> {
			asserts.assert(['odbc.dll', 'odbc.exp', 'odbc.obj', 'odbc.lib'].foreach(file -> {
				final retVal = exists(file);
				if (retVal)
					delete(file);
				return retVal;
			}));
			asserts.done();
		});
		return asserts;
	}

	public function test_gcc() {
		Cli.process(hxMake, new HxMake('gcc')).handle(() -> {
			asserts.assert(['odbc.dll', 'odbc.obj'].foreach(file -> {
				final retVal = exists(file);
				if (retVal)
					delete(file);
				return retVal;
			}));
			asserts.done();
		});
		return asserts;
	}


}
