/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:37 EST 2013 */

if (typeof aglsl == "undefined")
	var aglsl = {};

aglsl.Description = function() {
this.tokens = [];
this.samplers = [];
this.hasmatrix = false;
this.hasindirect = false;
this.header = new aglsl.Header();
this.regwrite = away.utils.VectorInit.AnyClass(7);
this.regread = away.utils.VectorInit.AnyClass(7);
this.writedepth = false;
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
