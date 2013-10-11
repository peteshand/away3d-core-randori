/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:07 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.loaders == "undefined")
	away.loaders = {};
if (typeof away.loaders.parsers == "undefined")
	away.loaders.parsers = {};

away.loaders.parsers.AWDProperties = function() {
	
};

away.loaders.parsers.AWDProperties.prototype.set = function(key, value) {
	this[key.toString(10)] = value;
};

away.loaders.parsers.AWDProperties.prototype.get = function(key, fallback) {
	console.log("this.hasOwnProperty(key.toString());", key, fallback, this.hasOwnProperty(key.toString(10)));
	if (this.hasOwnProperty(key.toString(10))) {
		return this[key.toString(10)];
	} else {
		return fallback;
	}
};

away.loaders.parsers.AWDProperties.className = "away.loaders.parsers.AWDProperties";

away.loaders.parsers.AWDProperties.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

away.loaders.parsers.AWDProperties.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.loaders.parsers.AWDProperties.injectionPoints = function(t) {
	return [];
};
