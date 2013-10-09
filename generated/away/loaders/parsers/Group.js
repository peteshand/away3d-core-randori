/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:41 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.loaders == "undefined")
	away.loaders = {};
if (typeof away.loaders.parsers == "undefined")
	away.loaders.parsers = {};

away.loaders.parsers.Group = function() {
this.name = null;
this.materialID = null;
this.materialGroups = [];
};

away.loaders.parsers.Group.className = "away.loaders.parsers.Group";

away.loaders.parsers.Group.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.loaders.parsers.Group.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.loaders.parsers.Group.injectionPoints = function(t) {
	return [];
};
