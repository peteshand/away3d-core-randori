/** Compiled by the Randori compiler v0.2.6.2 on Mon Sep 02 23:32:04 EST 2013 */

if (typeof aglsl == "undefined")
	var aglsl = {};
if (typeof aglsl.assembler == "undefined")
	aglsl.assembler = {};

aglsl.assembler.Reg = function(code, desc) {
	this.code = code;
	this.desc = desc;
};

aglsl.assembler.Reg.className = "aglsl.assembler.Reg";

aglsl.assembler.Reg.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

aglsl.assembler.Reg.getStaticDependencies = function(t) {
	var p;
	return [];
};

aglsl.assembler.Reg.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'code', t:'Number'});
			p.push({n:'desc', t:'String'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

