/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 28 11:54:32 EST 2013 */

if (typeof aglsl == "undefined")
	var aglsl = {};
if (typeof aglsl.assembler == "undefined")
	aglsl.assembler = {};

aglsl.assembler.OpcodeMap = function() {
this._map = null;
};

aglsl.assembler.OpcodeMap._map;

aglsl.assembler.OpcodeMap.get_map = function() {
	if (!aglsl.assembler.OpcodeMap._map) {
		aglsl.assembler.OpcodeMap._map = [];
		aglsl.assembler.OpcodeMap._map["mov"] = new aglsl.assembler.Opcode("vector", "vector", 4, "none", 0, 0x00, true, null, null, null);
		aglsl.assembler.OpcodeMap._map["add"] = new aglsl.assembler.Opcode("vector", "vector", 4, "vector", 4, 0x01, true, null, null, null);
		aglsl.assembler.OpcodeMap._map["sub"] = new aglsl.assembler.Opcode("vector", "vector", 4, "vector", 4, 0x02, true, null, null, null);
		aglsl.assembler.OpcodeMap._map["mul"] = new aglsl.assembler.Opcode("vector", "vector", 4, "vector", 4, 0x03, true, null, null, null);
		aglsl.assembler.OpcodeMap._map["div"] = new aglsl.assembler.Opcode("vector", "vector", 4, "vector", 4, 0x04, true, null, null, null);
		aglsl.assembler.OpcodeMap._map["rcp"] = new aglsl.assembler.Opcode("vector", "vector", 4, "none", 0, 0x05, true, null, null, null);
		aglsl.assembler.OpcodeMap._map["min"] = new aglsl.assembler.Opcode("vector", "vector", 4, "vector", 4, 0x06, true, null, null, null);
		aglsl.assembler.OpcodeMap._map["max"] = new aglsl.assembler.Opcode("vector", "vector", 4, "vector", 4, 0x07, true, null, null, null);
		aglsl.assembler.OpcodeMap._map["frc"] = new aglsl.assembler.Opcode("vector", "vector", 4, "none", 0, 0x08, true, null, null, null);
		aglsl.assembler.OpcodeMap._map["sqt"] = new aglsl.assembler.Opcode("vector", "vector", 4, "none", 0, 0x09, true, null, null, null);
		aglsl.assembler.OpcodeMap._map["rsq"] = new aglsl.assembler.Opcode("vector", "vector", 4, "none", 0, 0x0a, true, null, null, null);
		aglsl.assembler.OpcodeMap._map["pow"] = new aglsl.assembler.Opcode("vector", "vector", 4, "vector", 4, 0x0b, true, null, null, null);
		aglsl.assembler.OpcodeMap._map["log"] = new aglsl.assembler.Opcode("vector", "vector", 4, "none", 0, 0x0c, true, null, null, null);
		aglsl.assembler.OpcodeMap._map["exp"] = new aglsl.assembler.Opcode("vector", "vector", 4, "none", 0, 0x0d, true, null, null, null);
		aglsl.assembler.OpcodeMap._map["nrm"] = new aglsl.assembler.Opcode("vector", "vector", 4, "none", 0, 0x0e, true, null, null, null);
		aglsl.assembler.OpcodeMap._map["sin"] = new aglsl.assembler.Opcode("vector", "vector", 4, "none", 0, 0x0f, true, null, null, null);
		aglsl.assembler.OpcodeMap._map["cos"] = new aglsl.assembler.Opcode("vector", "vector", 4, "none", 0, 0x10, true, null, null, null);
		aglsl.assembler.OpcodeMap._map["crs"] = new aglsl.assembler.Opcode("vector", "vector", 4, "vector", 4, 0x11, true, true, null, null);
		aglsl.assembler.OpcodeMap._map["dp3"] = new aglsl.assembler.Opcode("vector", "vector", 4, "vector", 4, 0x12, true, true, null, null);
		aglsl.assembler.OpcodeMap._map["dp4"] = new aglsl.assembler.Opcode("vector", "vector", 4, "vector", 4, 0x13, true, true, null, null);
		aglsl.assembler.OpcodeMap._map["abs"] = new aglsl.assembler.Opcode("vector", "vector", 4, "none", 0, 0x14, true, null, null, null);
		aglsl.assembler.OpcodeMap._map["neg"] = new aglsl.assembler.Opcode("vector", "vector", 4, "none", 0, 0x15, true, null, null, null);
		aglsl.assembler.OpcodeMap._map["sat"] = new aglsl.assembler.Opcode("vector", "vector", 4, "none", 0, 0x16, true, null, null, null);
		aglsl.assembler.OpcodeMap._map["ted"] = new aglsl.assembler.Opcode("vector", "vector", 4, "sampler", 1, 0x26, true, null, true, null);
		aglsl.assembler.OpcodeMap._map["kil"] = new aglsl.assembler.Opcode("none", "scalar", 1, "none", 0, 0x27, true, null, true, null);
		aglsl.assembler.OpcodeMap._map["tex"] = new aglsl.assembler.Opcode("vector", "vector", 4, "sampler", 1, 0x28, true, null, true, null);
		aglsl.assembler.OpcodeMap._map["m33"] = new aglsl.assembler.Opcode("vector", "matrix", 3, "vector", 3, 0x17, true, null, null, true);
		aglsl.assembler.OpcodeMap._map["m44"] = new aglsl.assembler.Opcode("vector", "matrix", 4, "vector", 4, 0x18, true, null, null, true);
		aglsl.assembler.OpcodeMap._map["m43"] = new aglsl.assembler.Opcode("vector", "matrix", 3, "vector", 4, 0x19, true, null, null, true);
		aglsl.assembler.OpcodeMap._map["sge"] = new aglsl.assembler.Opcode("vector", "vector", 4, "vector", 4, 0x29, true, null, null, null);
		aglsl.assembler.OpcodeMap._map["slt"] = new aglsl.assembler.Opcode("vector", "vector", 4, "vector", 4, 0x2a, true, null, null, null);
		aglsl.assembler.OpcodeMap._map["sgn"] = new aglsl.assembler.Opcode("vector", "vector", 4, "vector", 4, 0x2b, true, null, null, null);
		aglsl.assembler.OpcodeMap._map["seq"] = new aglsl.assembler.Opcode("vector", "vector", 4, "vector", 4, 0x2c, true, null, null, null);
		aglsl.assembler.OpcodeMap._map["sne"] = new aglsl.assembler.Opcode("vector", "vector", 4, "vector", 4, 0x2d, true, null, null, null);
	}
	return aglsl.assembler.OpcodeMap._map;
};

aglsl.assembler.OpcodeMap.className = "aglsl.assembler.OpcodeMap";

aglsl.assembler.OpcodeMap.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('aglsl.assembler.Opcode');
	return p;
};

aglsl.assembler.OpcodeMap.getStaticDependencies = function(t) {
	var p;
	return [];
};

aglsl.assembler.OpcodeMap.injectionPoints = function(t) {
	return [];
};
