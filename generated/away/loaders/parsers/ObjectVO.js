/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:05 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.loaders == "undefined")
	away.loaders = {};
if (typeof away.loaders.parsers == "undefined")
	away.loaders.parsers = {};

away.loaders.parsers.ObjectVO = function() {
this.pivotX = 0;
this.pivotY = 0;
this.type = null;
this.pivotZ = 0;
this.smoothingGroups = null;
this.transform = null;
this.materials = null;
this.verts = null;
this.name = null;
this.indices = null;
this.materialFaces = null;
this.uvs = null;
};

away.loaders.parsers.ObjectVO.className = "away.loaders.parsers.ObjectVO";

away.loaders.parsers.ObjectVO.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.loaders.parsers.ObjectVO.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.loaders.parsers.ObjectVO.injectionPoints = function(t) {
	return [];
};
