/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:03 EST 2013 */

if (typeof aglsl == "undefined")
	var aglsl = {};

aglsl.Destination = function() {
this.mask = 0;
this.regnum = 0;
this.regtype = 0;
this.dim = 0;
};

aglsl.Destination.className = "aglsl.Destination";

aglsl.Destination.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

aglsl.Destination.getStaticDependencies = function(t) {
	var p;
	return [];
};

aglsl.Destination.injectionPoints = function(t) {
	return [];
};
