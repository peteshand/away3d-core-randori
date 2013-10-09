/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:40 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.pick == "undefined")
	away.core.pick = {};

away.core.pick.PickingColliderType = function() {
	
};

away.core.pick.PickingColliderType.BOUNDS_ONLY = null;

away.core.pick.PickingColliderType.AS3_FIRST_ENCOUNTERED = new away.core.pick.AS3PickingCollider(false);

away.core.pick.PickingColliderType.AS3_BEST_HIT = new away.core.pick.AS3PickingCollider(true);

away.core.pick.PickingColliderType.className = "away.core.pick.PickingColliderType";

away.core.pick.PickingColliderType.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.core.pick.PickingColliderType.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('away.core.pick.AS3PickingCollider');
	return p;
};

away.core.pick.PickingColliderType.injectionPoints = function(t) {
	return [];
};
