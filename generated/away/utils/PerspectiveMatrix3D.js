/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:41 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.utils == "undefined")
	away.utils = {};

away.utils.PerspectiveMatrix3D = function(v) {
	away.core.geom.Matrix3D.call(this, v);
};

away.utils.PerspectiveMatrix3D.prototype.perspectiveFieldOfViewLH = function(fieldOfViewY, aspectRatio, zNear, zFar) {
	var yScale = 1 / Math.tan(fieldOfViewY / 2);
	var xScale = yScale / aspectRatio;
	this.copyRawDataFrom([xScale, 0.0, 0.0, 0.0, 0.0, yScale, 0.0, 0.0, 0.0, 0.0, zFar / (zFar - zNear), 1.0, 0.0, 0.0, (zNear * zFar) / (zNear - zFar), 0.0], 0, false);
};

$inherit(away.utils.PerspectiveMatrix3D, away.core.geom.Matrix3D);

away.utils.PerspectiveMatrix3D.className = "away.utils.PerspectiveMatrix3D";

away.utils.PerspectiveMatrix3D.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.utils.PerspectiveMatrix3D.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.utils.PerspectiveMatrix3D.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'v', t:'Array'});
			break;
		case 1:
			p = away.core.geom.Matrix3D.injectionPoints(t);
			break;
		case 2:
			p = away.core.geom.Matrix3D.injectionPoints(t);
			break;
		case 3:
			p = away.core.geom.Matrix3D.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

