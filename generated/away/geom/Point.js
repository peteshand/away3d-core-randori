/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 10 22:28:14 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.geom == "undefined")
	away.geom = {};

away.geom.Point = function(x, y) {
	x = x;
	y = y;
};

away.geom.Point.className = "away.geom.Point";

away.geom.Point.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.geom.Point.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.geom.Point.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'x', t:'Number'});
			p.push({n:'y', t:'Number'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

