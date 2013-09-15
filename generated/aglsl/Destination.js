/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 10 22:31:10 EST 2013 */

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
