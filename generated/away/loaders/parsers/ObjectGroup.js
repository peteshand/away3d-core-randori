/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 25 00:03:28 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.loaders == "undefined")
	away.loaders = {};
if (typeof away.loaders.parsers == "undefined")
	away.loaders.parsers = {};

away.loaders.parsers.ObjectGroup = function() {
this.name = null;
this.groups = away.utils.VectorInit.AnyClass(away.loaders.parsers.Group);
};

away.loaders.parsers.ObjectGroup.className = "away.loaders.parsers.ObjectGroup";

away.loaders.parsers.ObjectGroup.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.loaders.parsers.ObjectGroup.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('away.loaders.parsers.Group');
	p.push('away.utils.VectorInit');
	return p;
};

away.loaders.parsers.ObjectGroup.injectionPoints = function(t) {
	return [];
};
