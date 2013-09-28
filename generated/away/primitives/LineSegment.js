/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 28 11:54:39 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.primitives == "undefined")
	away.primitives = {};

away.primitives.LineSegment = function(v0, v1, color0, color1, thickness) {
	this.TYPE = "line";
	color0 = color0 || 0x333333;
	color1 = color1 || 0x333333;
	thickness = thickness || 1;
	away.primitives.data.Segment.call(this, v0, v1, null, color0, color1, thickness);
};

$inherit(away.primitives.LineSegment, away.primitives.data.Segment);

away.primitives.LineSegment.className = "away.primitives.LineSegment";

away.primitives.LineSegment.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.primitives.LineSegment.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.primitives.LineSegment.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'v0', t:'away.geom.Vector3D'});
			p.push({n:'v1', t:'away.geom.Vector3D'});
			p.push({n:'color0', t:'Number'});
			p.push({n:'color1', t:'Number'});
			p.push({n:'thickness', t:'Number'});
			break;
		case 1:
			p = away.primitives.data.Segment.injectionPoints(t);
			break;
		case 2:
			p = away.primitives.data.Segment.injectionPoints(t);
			break;
		case 3:
			p = away.primitives.data.Segment.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

