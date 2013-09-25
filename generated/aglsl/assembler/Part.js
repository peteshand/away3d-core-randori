/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 24 23:06:48 EST 2013 */

if (typeof aglsl == "undefined")
	var aglsl = {};
if (typeof aglsl.assembler == "undefined")
	aglsl.assembler = {};

aglsl.assembler.Part = function(name, version) {
	this.data = null;
	name = name || null;
	version = version || null;
	this.name = name;
	this.version = version;
	this.data = new away.utils.ByteArray();
};

aglsl.assembler.Part.className = "aglsl.assembler.Part";

aglsl.assembler.Part.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.utils.ByteArray');
	return p;
};

aglsl.assembler.Part.getStaticDependencies = function(t) {
	var p;
	return [];
};

aglsl.assembler.Part.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'name', t:'String'});
			p.push({n:'version', t:'Number'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

