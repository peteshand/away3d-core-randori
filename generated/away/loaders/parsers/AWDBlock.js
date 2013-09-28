/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 28 11:54:52 EST 2013 */

if (typeof away == "undefined")
	var away = {};
if (typeof away.loaders == "undefined")
	away.loaders = {};
if (typeof away.loaders.parsers == "undefined")
	away.loaders.parsers = {};

away.loaders.parsers.AWDBlock = function() {
this.bytes = null;
this.errorMessages = null;
this.data = null;
this.len = null;
this.extras = null;
this.id = 0;
this.geoID = 0;
this.name = null;
this.uvsForVertexAnimation = null;
};

away.loaders.parsers.AWDBlock.prototype.dispose = function() {
	this.id = null;
	this.bytes = null;
	this.errorMessages = null;
	this.uvsForVertexAnimation = null;
};

away.loaders.parsers.AWDBlock.prototype.addError = function(errorMsg) {
	if (!this.errorMessages)
		this.errorMessages = away.utils.VectorInit.Str(0, "");
	this.errorMessages.push(errorMsg);
};

away.loaders.parsers.AWDBlock.className = "away.loaders.parsers.AWDBlock";

away.loaders.parsers.AWDBlock.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('away.utils.VectorInit');
	return p;
};

away.loaders.parsers.AWDBlock.getStaticDependencies = function(t) {
	var p;
	return [];
};

away.loaders.parsers.AWDBlock.injectionPoints = function(t) {
	return [];
};
