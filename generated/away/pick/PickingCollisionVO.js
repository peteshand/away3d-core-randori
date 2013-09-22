/** Compiled by the Randori compiler v0.2.6.2 on Sun Sep 22 12:28:42 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.pick == "undefined")
	away.pick = {};

away.pick.PickingCollisionVO = function(entity) {
	this.localRayDirection = null;
	this.index = 0;
	this.rayPosition = null;
	this.localPosition = null;
	this.rayEntryDistance = 0;
	this.renderable = null;
	this.rayOriginIsInsideBounds = null;
	this.subGeometryIndex = 0;
	this.uv = null;
	this.localRayPosition = null;
	this.localNormal = null;
	this.rayDirection = null;
	this.entity = entity;
};

away.pick.PickingCollisionVO.className = "away.pick.PickingCollisionVO";

away.pick.PickingCollisionVO.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.pick.PickingCollisionVO.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.pick.PickingCollisionVO.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'entity', t:'away.entities.Entity'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

