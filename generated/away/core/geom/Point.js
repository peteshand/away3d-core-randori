/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:39 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.geom == "undefined")
	away.core.geom = {};

away.core.geom.Point = function(x, y) {
	x = x || 0;
	y = y || 0;
	this.x = x;
	this.y = y;
};

away.core.geom.Point.className = "away.core.geom.Point";

away.core.geom.Point.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.core.geom.Point.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.core.geom.Point.injectionPoints = function(t) {
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

