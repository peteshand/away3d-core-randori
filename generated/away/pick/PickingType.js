/** Compiled by the Randori compiler v0.2.6.2 on Thu Sep 05 22:19:28 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.pick == "undefined")
	away.pick = {};

away.pick.PickingType = function() {
	
};

away.pick.PickingType.SHADER = new away.pick.ShaderPicker();

away.pick.PickingType.RAYCAST_FIRST_ENCOUNTERED = new away.pick.RaycastPicker(false);

away.pick.PickingType.RAYCAST_BEST_HIT = new away.pick.RaycastPicker(true);

away.pick.PickingType.className = "away.pick.PickingType";

away.pick.PickingType.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.pick.PickingType.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('away.pick.RaycastPicker');
	p.push('away.pick.ShaderPicker');
	return p;
};

away.pick.PickingType.injectionPoints = function(t) {
	return [];
};
