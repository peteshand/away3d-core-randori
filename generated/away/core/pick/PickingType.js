/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:08 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.pick == "undefined")
	away.core.pick = {};

away.core.pick.PickingType = function() {
	
};

away.core.pick.PickingType.SHADER = new away.core.pick.ShaderPicker();

away.core.pick.PickingType.RAYCAST_FIRST_ENCOUNTERED = new away.core.pick.RaycastPicker(false);

away.core.pick.PickingType.RAYCAST_BEST_HIT = new away.core.pick.RaycastPicker(true);

away.core.pick.PickingType.className = "away.core.pick.PickingType";

away.core.pick.PickingType.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.core.pick.PickingType.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('away.core.pick.ShaderPicker');
	p.push('away.core.pick.RaycastPicker');
	return p;
};

away.core.pick.PickingType.injectionPoints = function(t) {
	return [];
};
