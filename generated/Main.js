/** Compiled by the Randori compiler v0.2.6.2 on Wed Sep 25 20:39:34 EST 2013 */


Main = function() {
	
};

Main.prototype.main = function() {
	var planeTest = new examples.PlaneTest();
};

Main.className = "Main";

Main.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('examples.PlaneTest');
	return p;
};

Main.getStaticDependencies = function(t) {
	var p;
	return [];
};

Main.injectionPoints = function(t) {
	return [];
};
