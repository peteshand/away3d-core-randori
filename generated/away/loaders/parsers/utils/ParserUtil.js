/** Compiled by the Randori compiler v0.2.6.2 on Mon Sep 02 23:32:11 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.loaders == "undefined")
	away.loaders = {};
if (typeof away.loaders.parsers == "undefined")
	away.loaders.parsers = {};
if (typeof away.loaders.parsers.utils == "undefined")
	away.loaders.parsers.utils = {};

away.loaders.parsers.utils.ParserUtil = function() {
	
};

away.loaders.parsers.utils.ParserUtil.toByteArray = function(data) {
	var b = new away.utils.ByteArray();
	b.arraybytes = data;
	return b;
};

away.loaders.parsers.utils.ParserUtil.toString = function(data) {
	if (typeof(data) == "string")
	
	var s = data;
	return s.substr(0, s.length);
	return null;
};

away.loaders.parsers.utils.ParserUtil.className = "away.loaders.parsers.utils.ParserUtil";

away.loaders.parsers.utils.ParserUtil.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.utils.ByteArray');
	return p;
};

away.loaders.parsers.utils.ParserUtil.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.loaders.parsers.utils.ParserUtil.injectionPoints = function(t) {
	return [];
};
