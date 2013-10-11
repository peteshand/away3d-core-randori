/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:08 EST 2013 */

if (typeof aglsl == "undefined")
	var aglsl = {};

aglsl.Token = function() {
this.dest = new aglsl.Destination();
this.opcode = 0;
this.a = new aglsl.Destination();
this.b = new aglsl.Destination();
};

aglsl.Token.className = "aglsl.Token";

aglsl.Token.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

aglsl.Token.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('aglsl.Destination');
	return p;
};

aglsl.Token.injectionPoints = function(t) {
	return [];
};
