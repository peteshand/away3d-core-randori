/** Compiled by the Randori compiler v0.2.6.2 on Thu Sep 05 22:19:20 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};
if (typeof away.materials.methods == "undefined")
	away.materials.methods = {};

away.materials.methods.MethodVOSet = function(method) {
	this.data = null;
	method = method;
	this.data = method.iCreateMethodVO();
};

away.materials.methods.MethodVOSet.className = "away.materials.methods.MethodVOSet";

away.materials.methods.MethodVOSet.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.materials.methods.MethodVOSet.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.materials.methods.MethodVOSet.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'method', t:'away.materials.methods.EffectMethodBase'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

