package hxmake;
import tink.cli.*;
@:alias(false)
class HxMake {
    public function new() {}
    @:flag('-lib')
    public var libs:Array<String> = null;
    @:flag('-lib-path')
    public var libPaths:Array<String> = null;
    @:flag('-src')
    public var src:String;
    // @:flag('-include-path')
    @:flag('-include')
    public var includePaths:Array<String> = null;
    // public var includes:Array<String> = null;
    @:flag('-o')
    public var output:String;
    @:flag('-D')
    public var defines:Array<String> = null;
    @:defaultCommand
    public function run(rest:Rest<String>) {
        // trace(rest);
        new hxmake.compilers.CL().buildObjectBinaries(this);
        new hxmake.compilers.CL().buildConsumableBinaries(this);
        // cmd('cl', getCLArgs(rest));
    }
    public function getCLArgs(rest:Rest<String>) {
        
        trace({t: haxe.Json.stringify({args: this, rest: rest}, null, '\t')});
        Sys.exit(0);
        return [];
    }
}