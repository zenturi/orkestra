package orkestra;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import haxe.macro.Type as MacroType;
import haxe.macro.Compiler;
import tjson.TJSON;

using haxe.macro.Tools;
using haxe.macro.ComplexTypeTools;
using StringTools;

typedef TInport = {
	var name:String;
	var type:String;
};

typedef TOutport = {
	> TInport,
};

typedef TComponent = {
	var module:String;
	var inports:Array<TInport>;
	var outports:Array<TOutport>;
};

class Boot {
	static var components:Array<TComponent> = new Array<TComponent>();

	macro static public function init():Array<haxe.macro.Field> {
		var fields = Context.getBuildFields();
		var name = Context.getLocalClass().toString();
		var _component:TComponent = {
			module: name,
			inports: [],
			outports: []
		};
		var inports = [];
		for (field in fields) {
			for (candidate in field.meta) {
				switch (field.kind) {
					case FVar(t, e) | FProp(_, _, t, e):
						{
							if (candidate.name == 'inport') {
								_component.inports.push({
									name: field.name,
									type: t.toString()
								});
							}

							if (candidate.name == 'outport') {
								_component.outports.push({
									name: field.name,
									type: t.toString()
								});
							}
						}
					case _:
				}
			}
		}

		fields.push({
			name: "__trigger",
			access: [Access.APublic],
			pos: Context.currentPos(),
			kind: FFun({
				args: [],
				ret: null,
				expr: {
					pos: Context.currentPos(),
					expr: EBlock([
						{
							pos: Context.currentPos(),
							expr: ECall({
								pos: Context.currentPos(),
								expr: EField({
									pos: Context.currentPos(),
									expr: EField({
										pos: Context.currentPos(),
										expr: EConst(CIdent("this"))
									}, "inports")
								}, "dispatch")
							}, inportCallParams(_component.inports))
						},
						{
							pos: Context.currentPos(),
							expr: ECall({
								pos: Context.currentPos(),
								expr: EConst(CIdent("run"))
							}, [])
						},
						{
							pos: Context.currentPos(),
							expr: ECall({
								pos: Context.currentPos(),
								expr: EField({
									pos: Context.currentPos(),
									expr: EField({
										pos: Context.currentPos(),
										expr: EConst(CIdent("this"))
									}, "outports")
								}, "dispatch")
							}, outportCallParams(_component.outports))
						}
					])
				}
			})
		});
		components.push(_component);
        var config = TJSON.parse(sys.io.File.getContent(Sys.getCwd() + "orkestra.json"));
        config.components = components;
		sys.io.File.saveContent(Sys.getCwd() + "orkestra.json", TJSON.encode(config, "fancy"));

		return fields;
	}

	// macro static public function register():Array<haxe.macro.Field> {
	// 	var name = Context.getLocalModule().toString();

	// 	Context.onGenerate((x) -> {
	// 		for (t in x) {
	// 			try {
	// 				var ty = Context.resolveType(Context.toComplexType(t), Context.currentPos());
	// 				switch (ty){
    //                     case TInst(p, _):{
    //                         trace(p);
    //                     }
    //                     case _:
    //                 }
	// 			} catch (e:Dynamic) {}
	// 		}
	// 	});
	// 	var fields = Context.getBuildFields();
	// 	for (field in fields) {
	// 		if (field.name == "register") {
	// 			switch (field.kind) {
	// 				case FFun(func):
	// 					{
	// 						var exps = [];
	// 						if (components.length > 0) {
	// 							for (comp in components) {
	// 								var path = comp.module;

	// 								var _class = comp.module.split(".")[comp.module.split(".").length - 1];
	// 								var _pack = comp.module.split(".").slice(0, comp.module.split(".").indexOf(path));

	// 								exps.push({
	// 									pos: Context.currentPos(),
	// 									expr: EVars([
	// 										{
	// 											expr: {
	// 												pos: Context.currentPos(),
	// 												expr: ENew({
	// 													name: _class,
	// 													pack: _pack
	// 												}, [])
	// 											},
	// 											name: comp.module.replace(".", "_"),
	// 											type: TPath({
	// 												name: _class,
	// 												pack: _pack
	// 											})
	// 										}
	// 									])
	// 								});
	// 								exps.push({
	// 									pos: Context.currentPos(),
	// 									expr: ECall({
	// 										pos: Context.currentPos(),
	// 										expr: EField({
	// 											pos: Context.currentPos(),
	// 											expr: EField({
	// 												pos: Context.currentPos(),
	// 												expr: EConst(CIdent("Graph"))
	// 											}, "modules")
	// 										}, "push")
	// 									}, [
	// 											{
	// 												pos: Context.currentPos(),
	// 												expr: EConst(CIdent((comp.module.replace(".", "_"))))
	// 											}
	// 										])
	// 								});
	// 							}

	// 							func.expr = {
	// 								pos: Context.currentPos(),
	// 								expr: EBlock(exps)
	// 							};
	// 						}
	// 					}
	// 				case _:
	// 			}
	// 		}
	// 	}

	// 	return fields;
	// }

	private static function inportCallParams(inports:Array<Dynamic>) {
		var inp = [];
		for (i in inports) {
			inp.push({
				pos: Context.currentPos(),
				expr: EConst(CIdent(i.name))
			});
		}

		return inp;
	}

	private static function outportCallParams(outports:Array<Dynamic>) {
		var out = [];
		for (o in outports) {
			out.push({
				pos: Context.currentPos(),
				expr: EConst(CIdent(o.name))
			});
		}

		return out;
	}
}
#end
