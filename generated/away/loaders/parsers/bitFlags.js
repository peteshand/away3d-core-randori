/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 28 11:54:40 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.loaders == "undefined")
	away.loaders = {};
if (typeof away.loaders.parsers == "undefined")
	away.loaders.parsers = {};

away.loaders.parsers.bitFlags = function() {
	
};

away.loaders.parsers.bitFlags.FLAG1 = 1;

away.loaders.parsers.bitFlags.FLAG2 = 2;

away.loaders.parsers.bitFlags.FLAG3 = 4;

away.loaders.parsers.bitFlags.FLAG4 = 8;

away.loaders.parsers.bitFlags.FLAG5 = 16;

away.loaders.parsers.bitFlags.FLAG6 = 32;

away.loaders.parsers.bitFlags.FLAG7 = 64;

away.loaders.parsers.bitFlags.FLAG8 = 128;

away.loaders.parsers.bitFlags.FLAG9 = 256;

away.loaders.parsers.bitFlags.FLAG10 = 512;

away.loaders.parsers.bitFlags.FLAG11 = 1024;

away.loaders.parsers.bitFlags.FLAG12 = 2048;

away.loaders.parsers.bitFlags.FLAG13 = 4096;

away.loaders.parsers.bitFlags.FLAG14 = 8192;

away.loaders.parsers.bitFlags.FLAG15 = 16384;

away.loaders.parsers.bitFlags.FLAG16 = 32768;

away.loaders.parsers.bitFlags.test = function(flags, testFlag) {
	return (flags & testFlag) == testFlag;
};

away.loaders.parsers.bitFlags.className = "away.loaders.parsers.bitFlags";

away.loaders.parsers.bitFlags.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.loaders.parsers.bitFlags.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.loaders.parsers.bitFlags.injectionPoints = function(t) {
	return [];
};
