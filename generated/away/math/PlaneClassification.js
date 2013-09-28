/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 28 11:54:17 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.math == "undefined")
	away.math = {};

away.math.PlaneClassification = function() {
	
};

away.math.PlaneClassification.BACK = 0;

away.math.PlaneClassification.FRONT = 1;

away.math.PlaneClassification.IN = 0;

away.math.PlaneClassification.OUT = 1;

away.math.PlaneClassification.INTERSECT = 2;

away.math.PlaneClassification.className = "away.math.PlaneClassification";

away.math.PlaneClassification.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.math.PlaneClassification.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.math.PlaneClassification.injectionPoints = function(t) {
	return [];
};
