/** Compiled by the Randori compiler v0.2.6.2 on Sat Sep 21 12:58:49 EST 2013 */

if (typeof test == "undefined")
	var test = {};

test.VectorTest = function() {
	this._vec = [false];
	test.VectorTestBase.call(this, false);
};

$inherit(test.VectorTest, test.VectorTestBase);

test.VectorTest.className = "test.VectorTest";

test.VectorTest.getRuntimeDependencies = function(t) {
	var p;
	return [];
};

test.VectorTest.getStaticDependencies = function(t) {
	var p;
	return [];
};

test.VectorTest.injectionPoints = function(t) {
	var p;
	switch (t) {
		case 1:
			p = test.VectorTestBase.injectionPoints(t);
			break;
		case 2:
			p = test.VectorTestBase.injectionPoints(t);
			break;
		case 3:
			p = test.VectorTestBase.injectionPoints(t);
			break;
		default:
			p = [];
			break;
	}
	return p;
};

