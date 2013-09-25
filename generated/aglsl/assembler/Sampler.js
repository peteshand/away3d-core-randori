/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 24 23:06:44 EST 2013 */

if (typeof aglsl == "undefined")
	var aglsl = {};
if (typeof aglsl.assembler == "undefined")
	aglsl.assembler = {};

aglsl.assembler.Sampler = function(shift, mask, value) {
	this.shift = shift;
	this.mask = mask;
	this.value = value;
};

aglsl.assembler.Sampler.className = "aglsl.assembler.Sampler";

aglsl.assembler.Sampler.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

aglsl.assembler.Sampler.getStaticDependencies = function(t) {
	var p;
	return [];
};

aglsl.assembler.Sampler.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'shift', t:'Number'});
			p.push({n:'mask', t:'Number'});
			p.push({n:'value', t:'Number'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

