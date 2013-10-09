/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:41 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.materials == "undefined")
	away.materials = {};

away.materials.LightSources = function() {
	
};

away.materials.LightSources.LIGHTS = 0x01;

away.materials.LightSources.PROBES = 0x02;

away.materials.LightSources.ALL = 0x03;

away.materials.LightSources.className = "away.materials.LightSources";

away.materials.LightSources.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.materials.LightSources.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.materials.LightSources.injectionPoints = function(t) {
	return [];
};
