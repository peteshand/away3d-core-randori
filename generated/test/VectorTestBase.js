/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 21 12:44:59 EST 2013 */

if (typeof test == "undefined")
	var test = {};

test.VectorTestBase = function(v) {
};

test.VectorTestBase.className = "test.VectorTestBase";

test.VectorTestBase.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

test.VectorTestBase.getStaticDependencies = function(t) {
	var p;
	return [];
};

test.VectorTestBase.injectionPoints = function(t) {
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

