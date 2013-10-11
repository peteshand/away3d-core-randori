/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:05 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.loaders == "undefined")
	away.loaders = {};
if (typeof away.loaders.parsers == "undefined")
	away.loaders.parsers = {};

away.loaders.parsers.Parsers = function() {
	
};

away.loaders.parsers.Parsers.ALL_BUNDLED = [away.loaders.parsers.AWDParser, away.loaders.parsers.Max3DSParser, away.loaders.parsers.OBJParser];

away.loaders.parsers.Parsers.enableAllBundled = function() {
	away.loaders.misc.SingleFileLoader.enableParsers(away.loaders.parsers.Parsers.ALL_BUNDLED);
};

away.loaders.parsers.Parsers.className = "away.loaders.parsers.Parsers";

away.loaders.parsers.Parsers.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.loaders.misc.SingleFileLoader');
	return p;
};

away.loaders.parsers.Parsers.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('away.loaders.parsers.Max3DSParser');
	p.push('away.loaders.parsers.OBJParser');
	p.push('away.loaders.parsers.AWDParser');
	return p;
};

away.loaders.parsers.Parsers.injectionPoints = function(t) {
	return [];
};
