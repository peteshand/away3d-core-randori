/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:40 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.core == "undefined")
	away.core = {};
if (typeof away.core.display3D == "undefined")
	away.core.display3D = {};

away.core.display3D.Context3DClearMask = function() {
	
};

away.core.display3D.Context3DClearMask.COLOR = 8 << 11;

away.core.display3D.Context3DClearMask.DEPTH = 8 << 5;

away.core.display3D.Context3DClearMask.STENCIL = 8 << 7;

away.core.display3D.Context3DClearMask.ALL = away.core.display3D.Context3DClearMask.COLOR | away.core.display3D.Context3DClearMask.DEPTH | away.core.display3D.Context3DClearMask.STENCIL;

away.core.display3D.Context3DClearMask.className = "away.core.display3D.Context3DClearMask";

away.core.display3D.Context3DClearMask.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.core.display3D.Context3DClearMask.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.core.display3D.Context3DClearMask.injectionPoints = function(t) {
	return [];
};
