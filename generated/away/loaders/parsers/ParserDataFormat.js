/** Compiled by the Randori compiler v0.2.6.2 on Sun Sep 22 11:19:48 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.loaders == "undefined")
	away.loaders = {};
if (typeof away.loaders.parsers == "undefined")
	away.loaders.parsers = {};

away.loaders.parsers.ParserDataFormat = function() {
	
};

away.loaders.parsers.ParserDataFormat.BINARY = "binary";

away.loaders.parsers.ParserDataFormat.PLAIN_TEXT = "plainText";

away.loaders.parsers.ParserDataFormat.IMAGE = "image";

away.loaders.parsers.ParserDataFormat.className = "away.loaders.parsers.ParserDataFormat";

away.loaders.parsers.ParserDataFormat.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.loaders.parsers.ParserDataFormat.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.loaders.parsers.ParserDataFormat.injectionPoints = function(t) {
	return [];
};
