package test;

import orkestra.Graph;

class Test {
	public function new() {}

	static function main() {
		Graph.register(new test.Add());
		Graph.register(new test.Sub());
		Graph.register(new test.Tick());


		for(cls in Graph.modules){
		    if (Reflect.hasField(cls, "x")) Reflect.setField(cls, "x", 20);

		    if (Reflect.hasField(cls, "y")) Reflect.setField(cls, "y", 5);

		    if (Reflect.hasField(cls, "start")) Reflect.setField(cls, "start", true);
		    // if (Reflect.hasField(cls, "stop")) Reflect.setField(cls, "stop", true);

		    Reflect.field(cls, "outports").add((value)->{
		        trace(value);
		    }, false);

		    Reflect.field(cls, "__trigger")();
		}
	}
}
