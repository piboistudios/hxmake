package hxmake.compilers;

interface Compiler {
    function buildObjectBinaries(hxMakefile:HxMake):Void;
    function buildConsumableBinaries(hxMakefile:HxMake):Void;
}