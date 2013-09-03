/** Compiled by the Randori compiler v0.2.6.2 on Mon Sep 02 23:32:26 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.pick == "undefined")
	away.pick = {};

away.pick.PickingColliderType = function() {
	
};

away.pick.PickingColliderType.BOUNDS_ONLY = null;

away.pick.PickingColliderType.AS3_FIRST_ENCOUNTERED = new away.pick.AS3PickingCollider(false);

away.pick.PickingColliderType.AS3_BEST_HIT = new away.pick.AS3PickingCollider(true);

away.pick.PickingColliderType.className = "away.pick.PickingColliderType";

away.pick.PickingColliderType.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.pick.PickingColliderType.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('away.pick.AS3PickingCollider');
	return p;
};

away.pick.PickingColliderType.injectionPoints = function(t) {
	return [];
};
