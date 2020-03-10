# HxMake

HxMake is a Haxeified approach to writing build scripts and toolchains for native C intended to be compiled for use with FFI.

All it does is aggregate the flags and convert them to their appropriate flags on the selected compiler.

Right now it supports:
- gcc 
- cl.exe
- clang
- clang-cl

## HxMakefile

An HxMakefile looks something like this:
```
-D SOME_DEFINE=FOO
-lib odbc32
-src odbc.c
-o odbc.dll
-win-api
```

On cl (and clang-cl, barring the `cl`) would give you:
```
> cl /c odbc.c
> cl /LD odbc.obj /link /OUT:odbc.dll odbc32.lib
```

On gcc:
```
> gcc -c odbc.c -o odbc.obj
> gcc -mwindows -shared -o odbc.dll odbc.obj -o odbc.dll -lodbc32
```

The list of flags are:
- `-lib` - The name of a library; this can either be a .dll or a .lib file
- `-src` - The name of a C src file; right now, HxMake can only handle passing one source file to the underlying compiler toolchain
- `-include-path` - An include path; this directory should contain headers that are referenced by `-src`
- `-include-header` - A forcibly included header file; I don't see any real use for this, but both `gcc` and `cl` support it. This will effectively inject `#include <file>` at the top of your `-src` file.
- `-lib-path` - A library path to be searched in addition to the LIB environment variable. You might use this, for instance, to link the HashLink runtime (on gcc this is `-L` and on CL `/LIBPATH:`)
- `-win-api` - Indicates that the native code uses the Windows API; this only makes a difference on `gcc`, `cl` should already have the Windows environment set up (this adds `-mwindows` to the `gcc` command.)
- `-D` - A preprocessor define to be passed to the underlying C compiler.
- `-o` - The output file; this will be a either a .dll, .so, etc...

## Usage

You can compile HxMake from sources, however, right now, it has little use a standalone tool. It's main purpose is to facilitate some cross-platform compatibility in building for the [`anvil`](https://github.com/piboistudios/anvil) library.

## Native Extension Library Authors

You should use this within `anvil` by using `anvil`'s new `hxMakefile` option.

`anvil` will then run `HxMake` on the HxMakefile and users of your library can specify the compiler `HxMake` uses with `-D hxmake-compiler=<cl|gcc|clang|clang-cl>` in their project .hxml file.