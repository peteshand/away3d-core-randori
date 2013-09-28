/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 28 11:54:52 EST 2013 */

if (typeof aglsl == "undefined")
	var aglsl = {};

aglsl.Description = function() {
	this.tokens = [];
	this.samplers = away.utils.VectorInit.StarVec(0, "");
	this.hasmatrix = false;
	this.hasindirect = false;
	this.header = new aglsl.Header();
	this.regwrite = away.utils.VectorInit.StarVec(0, "");
	this.regread = away.utils.VectorInit.StarVec(0, "");
	this.writedepth = false;
	this.regread.push([], [], [], [], [], [], []);
	this.regwrite.push([], [], [], [], [], [], []);
};

aglsl.Description.className = "aglsl.Description";

aglsl.Description.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

aglsl.Description.getStaticDependencies = function(t) {
	var p;
	p = [];
	p.push('aglsl.Header');
	p.push('away.utils.VectorInit');
	return p;
};

aglsl.Description.injectionPoints = function(t) {
	return [];
};
