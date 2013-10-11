/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:08 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.loaders == "undefined")
	away.loaders = {};
if (typeof away.loaders.parsers == "undefined")
	away.loaders.parsers = {};

away.loaders.parsers.LoadedMaterial = function() {
this.cm = null;
this.ambientColor = 0xFFFFFF;
this.texture = null;
this.alpha = 1;
this.materialID = null;
this.specularMethod = null;
};

away.loaders.parsers.LoadedMaterial.className = "away.loaders.parsers.LoadedMaterial";

away.loaders.parsers.LoadedMaterial.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.loaders.parsers.LoadedMaterial.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.loaders.parsers.LoadedMaterial.injectionPoints = function(t) {
	return [];
};
