/** Compiled by the Randori compiler v0.2.6.2 on Tue Sep 03 00:13:40 EST 2013 */


Main = function() {
	
};

Main.prototype.main = function() {
	var planeTest = new myTests.PlaneTest();
};

Main.className = "Main";

Main.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('myTests.PlaneTest');
	return p;
};

Main.getStaticDependencies = function(t) {
	var p;
	return [];
};

Main.injectionPoints = function(t) {
	return [];
};
