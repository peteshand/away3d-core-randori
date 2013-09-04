/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 04 21:18:28 EST 2013 */

if (typeof aglsl == "undefined")
	var aglsl = {};
if (typeof aglsl.assembler == "undefined")
	aglsl.assembler = {};

aglsl.assembler.RegMap = function() {
this._map = null;
};

aglsl.assembler.RegMap._map;

aglsl.assembler.RegMap.get_map = function() {
	if (!aglsl.assembler.RegMap._map) {
		aglsl.assembler.RegMap._map = [];
		aglsl.assembler.RegMap._map["va"] = new aglsl.assembler.Reg(0x00, "vertex attribute");
		aglsl.assembler.RegMap._map["fc"] = new aglsl.assembler.Reg(0x01, "fragment constant");
		aglsl.assembler.RegMap._map["vc"] = new aglsl.assembler.Reg(0x01, "vertex constant");
		aglsl.assembler.RegMap._map["ft"] = new aglsl.assembler.Reg(0x02, "fragment temporary");
		aglsl.assembler.RegMap._map["vt"] = new aglsl.assembler.Reg(0x02, "vertex temporary");
		aglsl.assembler.RegMap._map["vo"] = new aglsl.assembler.Reg(0x03, "vertex output");
		aglsl.assembler.RegMap._map["op"] = new aglsl.assembler.Reg(0x03, "vertex output");
		aglsl.assembler.RegMap._map["fd"] = new aglsl.assembler.Reg(0x03, "fragment depth output");
		aglsl.assembler.RegMap._map["fo"] = new aglsl.assembler.Reg(0x03, "fragment output");
		aglsl.assembler.RegMap._map["oc"] = new aglsl.assembler.Reg(0x03, "fragment output");
		aglsl.assembler.RegMap._map["v"] = new aglsl.assembler.Reg(0x04, "varying");
		aglsl.assembler.RegMap._map["vi"] = new aglsl.assembler.Reg(0x04, "varying output");
		aglsl.assembler.RegMap._map["fi"] = new aglsl.assembler.Reg(0x04, "varying input");
		aglsl.assembler.RegMap._map["fs"] = new aglsl.assembler.Reg(0x05, "sampler");
	}
	return aglsl.assembler.RegMap._map;
};

aglsl.assembler.RegMap.className = "aglsl.assembler.RegMap";

aglsl.assembler.RegMap.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('aglsl.assembler.Reg');
	return p;
};

aglsl.assembler.RegMap.getStaticDependencies = function(t) {
	var p;
	return [];
};

aglsl.assembler.RegMap.injectionPoints = function(t) {
	return [];
};
