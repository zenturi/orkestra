package orkestra;

// #if !macro
// @:autoBuild(orkestra.Boot.register())
// #end
// @:keep
// @:keepSub
// class GraphRef {
// }


class Graph  /*extends GraphRef*/ {
    public static var modules:Array<Dynamic> = new Array<Dynamic>();
    public static function register(mod:Dynamic){
        modules.push(mod);
    }
}