class Run {
    public static function main() {
        try {
            var args = Sys.args();
            args = args.slice(0, args.length-1);
            hxmake.HxMake.main(args);
        } catch(e:Dynamic) {
            trace('Bad args: ${Sys.args()}');
            trace(e);
        }
    }
}