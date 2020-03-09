import tink.testrunner.*;
import tink.unit.*;
import tink.unit.Assert.assert;
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
	public function new() {}

	function readHxMake() {
		return ~/(\s|$)/gi.split(sys.io.File.getContent("./test.hxmake")).filter(s -> s.length!=0);
    }
    var hxMake:Array<String>;
    public function test_read_hxMake() {
        hxMake = readHxMake();
        trace(hxMake);
        return assert(hxMake.length !=0);
    }
	public function test_flags() {
		Cli.process(hxMake, new HxMake()).handle(Cli.exit);
		return assert(true);
	}
}
