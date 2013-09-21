/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 21 16:02:23 EST 2013 */

if (typeof aglsl == "undefined")
	var aglsl = {};

aglsl.Description = function() {
	this.tokens = [];
	this.samplers = [];
	this.hasmatrix = false;
	this.hasindirect = false;
	this.header = new aglsl.Header();
	this.regwrite = [];
	this.regread = [];
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
	return p;
};

aglsl.Description.injectionPoints = function(t) {
	return [];
};
