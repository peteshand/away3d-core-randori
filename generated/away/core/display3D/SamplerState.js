/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:40 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.display3D == "undefined")
	away.core.display3D = {};

away.core.display3D.SamplerState = function() {
	this.wrap = 0;
	this.filter = 0;
	this.mipfilter = 0;
	
};

away.core.display3D.SamplerState.className = "away.core.display3D.SamplerState";

away.core.display3D.SamplerState.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.core.display3D.SamplerState.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.core.display3D.SamplerState.injectionPoints = function(t) {
	return [];
};
