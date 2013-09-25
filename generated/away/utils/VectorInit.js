/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 25 08:08:25 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.utils == "undefined")
	away.utils = {};

away.utils.VectorInit = function() {
	
};

away.utils.VectorInit.Num = function(length, defaultValue, v) {
	length = length || 0;
	defaultValue = defaultValue || 0;
	if (!v)
		v = [];
	return away.utils.VectorInit.Pop(v, defaultValue, length);
};

away.utils.VectorInit.Str = function(length, defaultValue, v) {
	length = length || 0;
	defaultValue = defaultValue || "";
	if (!v)
		v = [];
	return away.utils.VectorInit.Pop(v, defaultValue, length);
};

away.utils.VectorInit.Bool = function(length, defaultValue, v) {
	length = length || 0;
	defaultValue = defaultValue || false;
	if (!v)
		v = [];
	return away.utils.VectorInit.Pop(v, defaultValue, length);
};

away.utils.VectorInit.VecNum = function(length, defaultValue, v) {
	length = length || 0;
	defaultValue = defaultValue || 0;
	if (!v)
		v = [];
	for (var g = 0; g < length; ++g)
		v.push(away.utils.VectorInit.Num(0, 0));
	return v;
};

away.utils.VectorInit.StarVec = function(length, defaultValue) {
	length = length || 0;
	defaultValue = defaultValue || "";
	var initVec = [];
	for (var g = 0; g < length; ++g)
		initVec.push(defaultValue);
	return initVec;
};

away.utils.VectorInit.AnyClass = function(_class, length) {
	length = length || 0;
	var v = [];
	for (var g = 0; g < length; ++g)
		v.push(null);
	return v;
};

away.utils.VectorInit.Pop = function(v, defaultValue, length) {
	length = length || 0;
	if (length == 0)
		return v;
	for (var g = 0; g < length; ++g)
		v[g] = defaultValue;
	return v;
};

away.utils.VectorInit.className = "away.utils.VectorInit";

away.utils.VectorInit.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.utils.VectorInit.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.utils.VectorInit.injectionPoints = function(t) {
	return [];
};
