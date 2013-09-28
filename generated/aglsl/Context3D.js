/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 28 11:54:52 EST 2013 */

if (typeof aglsl == "undefined")
	var aglsl = {};

aglsl.Context3D = function() {
this.resources = away.utils.VectorInit.StarVec(0, "");
this.enableErrorChecking = false;
this.driverInfo = "Call getter function instead";
};

aglsl.Context3D.maxvertexconstants = 128;

aglsl.Context3D.maxfragconstants = 28;

aglsl.Context3D.maxtemp = 8;

aglsl.Context3D.maxstreams = 8;

aglsl.Context3D.maxtextures = 8;

aglsl.Context3D.defaultsampler = new aglsl.Sampler();

aglsl.Context3D.className = "aglsl.Context3D";

aglsl.Context3D.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

aglsl.Context3D.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('aglsl.Sampler');
	p.push('away.utils.VectorInit');
	return p;
};

aglsl.Context3D.injectionPoints = function(t) {
	return [];
};
