/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 21 13:09:36 EST 2013 */

if (typeof test == "undefined")
	var test = {};

test.SuperTestBase = function(v) {
};

test.SuperTestBase.className = "test.SuperTestBase";

test.SuperTestBase.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

test.SuperTestBase.getStaticDependencies = function(t) {
	var p;
	return [];
};

test.SuperTestBase.injectionPoints = function(t) {
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

