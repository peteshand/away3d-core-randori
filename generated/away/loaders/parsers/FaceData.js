/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 28 11:54:52 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.loaders == "undefined")
	away.loaders = {};
if (typeof away.loaders.parsers == "undefined")
	away.loaders.parsers = {};

away.loaders.parsers.FaceData = function() {
this.vertexIndices = away.utils.VectorInit.Num(0, 0);
this.uvIndices = away.utils.VectorInit.Num(0, 0);
this.normalIndices = away.utils.VectorInit.Num(0, 0);
this.indexIds = away.utils.VectorInit.Str(0, "");
};

away.loaders.parsers.FaceData.className = "away.loaders.parsers.FaceData";

away.loaders.parsers.FaceData.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.loaders.parsers.FaceData.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('away.utils.VectorInit');
	return p;
};

away.loaders.parsers.FaceData.injectionPoints = function(t) {
	return [];
};
