package hxmake.compilers;
import haxe.io.Path;
typedef ArgList = Array<String>;
interface Compiler {
    var cmd:String;
    function getSrcCompilationOptions():ArgList;
    function getIncludePathOption(p:Path):ArgList;
    function getIncludeOption(p:Path):ArgList;
    function getBinaryCompilationOptions():ArgList;
    function getDefineOption(p:String):ArgList;
    function getOutputOptions():ArgList;
    function getLibPathIncludeOption(p:Path):ArgList;
    function getLibOption(lib:Path):ArgList;
}