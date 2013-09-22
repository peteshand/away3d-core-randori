/** Compiled by the Randori compiler v0.2.6.2 on Sun Sep 22 12:43:14 EST 2013 */


Main = function() {
	
};

Main.prototype.main = function() {
	var cubeDemo = new examples.CubeDemo();
};

Main.className = "Main";

Main.getRuntimeDependencies = function(t) {
	var p;
	p = [];
	p.push('examples.CubeDemo');
	return p;
};

Main.getStaticDependencies = function(t) {
	var p;
	return [];
};

Main.injectionPoints = function(t) {
	return [];
};
