/** Compiled by the Randori compiler v0.2.6.2 on Sun Sep 22 11:21:18 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.utils == "undefined")
	away.utils = {};

away.utils.VectorNumber = function() {
	
};

away.utils.VectorNumber.init = function(length, defaultValue, v) {
	length = length || 0;
	defaultValue = defaultValue || 0;
	if (!v)
		v = [];
	for (var g = 0; g < length; ++g)
		v[g] = defaultValue;
	return v;
};

away.utils.VectorNumber.className = "away.utils.VectorNumber";

away.utils.VectorNumber.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.utils.VectorNumber.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.utils.VectorNumber.injectionPoints = function(t) {
	return [];
};
