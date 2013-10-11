/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:00 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.math == "undefined")
	away.core.math = {};

away.core.math.PlaneClassification = function() {
	
};

away.core.math.PlaneClassification.BACK = 0;

away.core.math.PlaneClassification.FRONT = 1;

away.core.math.PlaneClassification.IN = 0;

away.core.math.PlaneClassification.OUT = 1;

away.core.math.PlaneClassification.INTERSECT = 2;

away.core.math.PlaneClassification.className = "away.core.math.PlaneClassification";

away.core.math.PlaneClassification.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.core.math.PlaneClassification.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.core.math.PlaneClassification.injectionPoints = function(t) {
	return [];
};
