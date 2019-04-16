package test;

import orkestra.ports.*;
import orkestra.Component;

@:keep
@:keepSub
class Add extends Component {
	@inport public var x:Int;
	@inport public var y:Int;
	@outport public var result:Int;

	public var inports:InPorts<Int->Int->Void> = new InPorts<Int->Int->Void>();

	public var outports:InPorts<Int->Void> = new InPorts<Int->Void>();
	public function new() {
		super();
	}

	private function run() {
		result = x + y;
	}

}
