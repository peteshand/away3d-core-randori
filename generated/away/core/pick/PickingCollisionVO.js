/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:03 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.pick == "undefined")
	away.core.pick = {};

away.core.pick.PickingCollisionVO = function(entity) {
	this.localRayDirection = null;
	this.index = 0;
	this.rayPosition = null;
	this.localPosition = null;
	this.rayEntryDistance = 0;
	this.renderable = null;
	this.rayOriginIsInsideBounds = false;
	this.subGeometryIndex = 0;
	this.uv = null;
	this.localRayPosition = null;
	this.localNormal = null;
	this.rayDirection = null;
	this.entity = entity;
};

away.core.pick.PickingCollisionVO.className = "away.core.pick.PickingCollisionVO";

away.core.pick.PickingCollisionVO.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.core.pick.PickingCollisionVO.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.core.pick.PickingCollisionVO.injectionPoints = function(t) {
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

