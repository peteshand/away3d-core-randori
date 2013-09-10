/** Compiled by the Randori compiler v0.2.6.2 on Thu Sep 05 22:19:07 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.display3D == "undefined")
	away.display3D = {};

away.display3D.SamplerState = function() {
	this.wrap = 0;
	this.filter = 0;
	this.mipfilter = 0;
	
};

away.display3D.SamplerState.className = "away.display3D.SamplerState";

away.display3D.SamplerState.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.display3D.SamplerState.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.display3D.SamplerState.injectionPoints = function(t) {
	return [];
};
