/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:06 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.loaders == "undefined")
	away.loaders = {};
if (typeof away.loaders.parsers == "undefined")
	away.loaders.parsers = {};

away.loaders.parsers.MaterialVO = function() {
this.specularMap = null;
this.twoSided = false;
this.ambientColor = 0;
this.specularColor = 0;
this.name = null;
this.diffuseColor = 0;
this.material = null;
this.colorMap = null;
};

away.loaders.parsers.MaterialVO.className = "away.loaders.parsers.MaterialVO";

away.loaders.parsers.MaterialVO.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.loaders.parsers.MaterialVO.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.loaders.parsers.MaterialVO.injectionPoints = function(t) {
	return [];
};
