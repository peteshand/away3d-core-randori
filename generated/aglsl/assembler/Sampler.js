/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 10 22:29:42 EST 2013 */

if (typeof aglsl == "undefined")
	var aglsl = {};
if (typeof aglsl.assembler == "undefined")
	aglsl.assembler = {};

aglsl.assembler.Sampler = function(shift, mask, value) {
	shift = shift;
	mask = mask;
	value = value;
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

