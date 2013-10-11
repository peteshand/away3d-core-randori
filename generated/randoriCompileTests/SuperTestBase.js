/** Compiled by the Randori compiler v0.2.5.2 on Sat Oct 12 02:16:04 EST 2013 */

if (typeof randoriCompileTests == "undefined")
	var randoriCompileTests = {};

randoriCompileTests.SuperTestBase = function(v) {
};

randoriCompileTests.SuperTestBase.className = "randoriCompileTests.SuperTestBase";

randoriCompileTests.SuperTestBase.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

randoriCompileTests.SuperTestBase.getStaticDependencies = function(t) {
	var p;
	return [];
};

randoriCompileTests.SuperTestBase.injectionPoints = function(t) {
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

