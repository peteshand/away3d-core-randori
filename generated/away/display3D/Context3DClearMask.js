/** Compiled by the Randori compiler v0.2.6.2 on Sun Sep 22 12:28:42 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.display3D == "undefined")
	away.display3D = {};

away.display3D.Context3DClearMask = function() {
	
};

away.display3D.Context3DClearMask.COLOR = 8 << 11;

away.display3D.Context3DClearMask.DEPTH = 8 << 5;

away.display3D.Context3DClearMask.STENCIL = 8 << 7;

away.display3D.Context3DClearMask.ALL = away.display3D.Context3DClearMask.COLOR | away.display3D.Context3DClearMask.DEPTH | away.display3D.Context3DClearMask.STENCIL;

away.display3D.Context3DClearMask.className = "away.display3D.Context3DClearMask";

away.display3D.Context3DClearMask.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.display3D.Context3DClearMask.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.display3D.Context3DClearMask.injectionPoints = function(t) {
	return [];
};
