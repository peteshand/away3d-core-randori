/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 21 16:01:56 EST 2013 */

if (typeof aglsl == "undefined")
	var aglsl = {};
if (typeof aglsl.assembler == "undefined")
	aglsl.assembler = {};

aglsl.assembler.Flags = function() {
	this.simple = null;
	this.horizontal = null;
	this.fragonly = null;
	this.matrix = null;
	
};

aglsl.assembler.Flags.className = "aglsl.assembler.Flags";

aglsl.assembler.Flags.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

aglsl.assembler.Flags.getStaticDependencies = function(t) {
	var p;
	return [];
};

aglsl.assembler.Flags.injectionPoints = function(t) {
	return [];
};
