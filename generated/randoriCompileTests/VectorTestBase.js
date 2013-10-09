/** Compiled by the Randori compiler v0.2.5.2 on Wed Oct 09 20:30:37 EST 2013 */

if (typeof randoriCompileTests == "undefined")
	var randoriCompileTests = {};

randoriCompileTests.VectorTestBase = function(v) {
};

randoriCompileTests.VectorTestBase.className = "randoriCompileTests.VectorTestBase";

randoriCompileTests.VectorTestBase.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

randoriCompileTests.VectorTestBase.getStaticDependencies = function(t) {
	var p;
	return [];
};

randoriCompileTests.VectorTestBase.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 0:
			p = [];
			p.push({n:'v', t:'Boolean'});
			break;
		default:
			p = [];
			break;
	}
	return p;
};

