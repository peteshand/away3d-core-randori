/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:03 EST 2013 */

if (typeof aglsl == "undefined")
	var aglsl = {};
if (typeof aglsl.assembler == "undefined")
	aglsl.assembler = {};

aglsl.assembler.Flags = function() {
	this.simple = false;
	this.horizontal = false;
	this.fragonly = false;
	this.matrix = false;
	
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
