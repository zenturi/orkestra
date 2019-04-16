package test;


import orkestra.ports.*;
import orkestra.Component;

@:keep
@:keepSub
class Tick extends Component {
	@inport public var start:Bool = true;
	@inport public var stop:Bool = false;
	@outport public var deltaTime:Float = 0;

	private var startTime:Int = 0;

	public var inports:InPorts<Bool->Bool->Void> = new InPorts<Bool->Bool->Void>();
	public var outports:InPorts<Float->Void> = new InPorts<Float->Void>();

	public function new() {
		super();
	}

	private var lastTime = Date.now().getSeconds()/1000;
	private function run() {
		
		while(start) {
			var time = Date.now().getSeconds()/1000;
			var elapsed = time - lastTime;
			this.outports.dispatch(elapsed);
			Sys.sleep(time + 0.06 - Date.now().getSeconds()/1000);
			lastTime = time;
		}
	}
}
