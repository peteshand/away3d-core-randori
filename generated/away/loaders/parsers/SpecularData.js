/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 24 22:31:33 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.loaders == "undefined")
	away.loaders = {};
if (typeof away.loaders.parsers == "undefined")
	away.loaders.parsers = {};

away.loaders.parsers.SpecularData = function() {
this.materialID = null;
this.basicSpecularMethod = null;
this.ambientColor = 0xFFFFFF;
this.alpha = 1;
};

away.loaders.parsers.SpecularData.className = "away.loaders.parsers.SpecularData";

away.loaders.parsers.SpecularData.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.loaders.parsers.SpecularData.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.loaders.parsers.SpecularData.injectionPoints = function(t) {
	return [];
};
