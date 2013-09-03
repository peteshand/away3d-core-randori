/** Compiled by the Randori compiler v0.2.6.2 on Mon Sep 02 23:32:23 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.traverse == "undefined")
	away.traverse = {};

away.traverse.RaycastCollector = function() {
	this._rayDirection = new away.geom.Vector3D(0, 0, 0, 0);
	this._rayPosition = new away.geom.Vector3D(0, 0, 0, 0);
	away.traverse.EntityCollector.call(this);
};

away.traverse.RaycastCollector.prototype.get_rayPosition = function() {
	return this._rayPosition;
};

away.traverse.RaycastCollector.prototype.set_rayPosition = function(value) {
	this._rayPosition = value;
};

away.traverse.RaycastCollector.prototype.get_rayDirection = function() {
	return this._rayDirection;
};

away.traverse.RaycastCollector.prototype.set_rayDirection = function(value) {
	this._rayDirection = value;
};

away.traverse.RaycastCollector.prototype.enterNode = function(node) {
	return node.isIntersectingRay(this._rayPosition, this._rayDirection);
};

away.traverse.RaycastCollector.prototype.applySkyBox = function(renderable) {
};

away.traverse.RaycastCollector.prototype.applyRenderable = function(renderable) {
};

away.traverse.RaycastCollector.prototype.applyUnknownLight = function(light) {
};

$inherit(away.traverse.RaycastCollector, away.traverse.EntityCollector);

away.traverse.RaycastCollector.className = "away.traverse.RaycastCollector";

away.traverse.RaycastCollector.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.traverse.RaycastCollector.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('away.geom.Vector3D');
	return p;
};

away.traverse.RaycastCollector.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 1:
			p = away.traverse.EntityCollector.injectionPoints(t);
			break;
		case 2:
			p = away.traverse.EntityCollector.injectionPoints(t);
			break;
		case 3:
			p = away.traverse.EntityCollector.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

