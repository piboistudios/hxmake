class Run {
    public static function main() {
        var args = Sys.args();
        try {
            var lastArg = args.splice(args.length-1, 1);
            Sys.setCwd(lastArg[0]);
            hxmake.HxMake.main(args);
        } catch(e:Dynamic) {
            trace('Bad args: ${args}');
            trace(e);
        }
    }
}