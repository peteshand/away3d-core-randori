/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 21 13:09:36 EST 2013 */

if (typeof test == "undefined")
	var test = {};

test.SuperTest = function() {
	this._vec = [];
	test.SuperTestBase.call(this, false);
};

$inherit(test.SuperTest, test.SuperTestBase);

test.SuperTest.className = "test.SuperTest";

test.SuperTest.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

test.SuperTest.getStaticDependencies = function(t) {
	var p;
	return [];
};

test.SuperTest.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 1:
			p = test.SuperTestBase.injectionPoints(t);
			break;
		case 2:
			p = test.SuperTestBase.injectionPoints(t);
			break;
		case 3:
			p = test.SuperTestBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

