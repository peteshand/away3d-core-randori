/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:06 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.loaders == "undefined")
	away.loaders = {};
if (typeof away.loaders.parsers == "undefined")
	away.loaders.parsers = {};

away.loaders.parsers.VertexVO = function() {
this.v = 0;
this.u = 0;
this.tangent = null;
this.normal = null;
this.z = 0;
this.y = 0;
this.x = 0;
};

away.loaders.parsers.VertexVO.className = "away.loaders.parsers.VertexVO";

away.loaders.parsers.VertexVO.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.loaders.parsers.VertexVO.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.loaders.parsers.VertexVO.injectionPoints = function(t) {
	return [];
};
