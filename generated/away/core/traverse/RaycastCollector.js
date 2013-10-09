/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:37 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.traverse == "undefined")
	away.core.traverse = {};

away.core.traverse.RaycastCollector = function() {
	this._rayDirection = new away.core.geom.Vector3D(0, 0, 0, 0);
	this._rayPosition = new away.core.geom.Vector3D(0, 0, 0, 0);
	away.core.traverse.EntityCollector.call(this);
};

away.core.traverse.RaycastCollector.prototype.get_rayPosition = function() {
	return this._rayPosition;
};

away.core.traverse.RaycastCollector.prototype.set_rayPosition = function(value) {
	this._rayPosition = value;
};

away.core.traverse.RaycastCollector.prototype.get_rayDirection = function() {
	return this._rayDirection;
};

away.core.traverse.RaycastCollector.prototype.set_rayDirection = function(value) {
	this._rayDirection = value;
};

away.core.traverse.RaycastCollector.prototype.enterNode = function(node) {
	return node.isIntersectingRay(this._rayPosition, this._rayDirection);
};

away.core.traverse.RaycastCollector.prototype.applySkyBox = function(renderable) {
};

away.core.traverse.RaycastCollector.prototype.applyRenderable = function(renderable) {
};

away.core.traverse.RaycastCollector.prototype.applyUnknownLight = function(light) {
};

$inherit(away.core.traverse.RaycastCollector, away.core.traverse.EntityCollector);

away.core.traverse.RaycastCollector.className = "away.core.traverse.RaycastCollector";

away.core.traverse.RaycastCollector.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.core.traverse.RaycastCollector.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('away.core.geom.Vector3D');
	return p;
};

away.core.traverse.RaycastCollector.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 1:
			p = away.core.traverse.EntityCollector.injectionPoints(t);
			break;
		case 2:
			p = away.core.traverse.EntityCollector.injectionPoints(t);
			break;
		case 3:
			p = away.core.traverse.EntityCollector.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

